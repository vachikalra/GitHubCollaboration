//
//  ContentView.swift
//  GitHubCollaboration
//
//  Created by Vachi Kalra on 7/29/25.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    enum Section: String, CaseIterable, Identifiable {
        case tasks = "Tasks"
        case wellness = "Wellness"
        case challenges = "Challenges"
        var id: String { self.rawValue }
    }

    @State private var selection: Section? = .tasks
    @State private var tasks: [TaskItem] = []
    @State private var newTask = ""
    @State private var challengeInput = ""
    @State private var selectedGroup: String? = nil

    var body: some View {
        NavigationSplitView {
            List(Section.allCases, selection: $selection) { section in
                NavigationLink(section.rawValue, value: section)
            }
            .navigationTitle("StudyBuddy")
        } detail: {
            ZStack {
                Color.purple.opacity(0.1).ignoresSafeArea()
                switch selection {
                case .tasks:
                    taskView
                case .wellness:
                    wellnessView
                case .challenges:
                    challengeView
                default:
                    Text("Select a section")
                }
            }
        }
    }

    // Task View
    var taskView: some View {
        VStack {
            Text("Tasks").font(.largeTitle).bold().padding()

            List {
                ForEach(tasks) { task in
                    HStack {
                        Text(task.title)
                            .strikethrough(task.isCompleted)
                            .foregroundColor(task.isCompleted ? .gray : .black)
                        Spacer()
                        if !task.isCompleted {
                            Button(action: {
                                markTaskComplete(task)
                            }) {
                                Image(systemName: "checkmark.circle")
                            }
                        }
                    }
                }
                .onDelete { indexSet in
                    tasks.remove(atOffsets: indexSet)
                }
            }

            HStack {
                TextField("Enter a task...", text: $newTask)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Add") {
                    if !newTask.isEmpty {
                        tasks.append(TaskItem(title: newTask))
                        newTask = ""
                    }
                }
                .padding(.horizontal)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
        }
    }

    // Wellness View
    var wellnessView: some View {
        VStack(spacing: 16) {
            Text("Choose Your Group").font(.title2).bold().padding()
            HStack(spacing: 20) {
                Button("Middle School") { selectedGroup = "Middle School" }
                Button("High School") { selectedGroup = "High School" }
                Button("College") { selectedGroup = "College" }
            }
            .buttonStyle(.borderedProminent)

            if let group = selectedGroup {
                adviceView(for: group)
            }
        }
    }

    func adviceView(for group: String) -> some View {
        let tips: [String]
        switch group {
        case "Middle School":
            tips = [
                "Take breaks when studying to avoid burnout.",
                "Talk to a trusted adult when you're feeling overwhelmed.",
                "Get at least 8-10 hours of sleep every night.",
                "Limit screen time before bed to improve sleep.",
                "Stay active, even 20 mins of movement helps mood."
            ]
        case "High School":
            tips = [
                "Don't compare yourself to others, your journey is unique.",
                "Balance school with things you love to avoid stress.",
                "Stay organized with planners or apps like StudyBuddy!",
                "Set small, realistic goals to avoid procrastination.",
                "Sleep is just as important as studying. Prioritize it."
            ]
        default:
            tips = [
                "Check in with yourself often, mental health matters.",
                "Don’t overcommit. Rest is productive too.",
                "Stay connected with friends or support groups.",
                "Create boundaries between school and rest time.",
                "Reach out for help if you’re struggling - you’re not alone."
            ]
        }

        return VStack(alignment: .leading, spacing: 8) {
            Text("Wellness Tips for \(group)").font(.title3).bold().padding(.top)
            ForEach(tips, id: \ .self) { tip in
                Text("• \(tip)")
            }
        }.padding()
    }

    // Challenge View
    var challengeView: some View {
        VStack(spacing: 16) {
            Text("What do you want reminders for every few hours?")
                .font(.headline)
                .padding()

            TextField("e.g. Drink water", text: $challengeInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button("Add Reminder") {
                if !challengeInput.isEmpty {
                    let newChallenge = "⏰ \(challengeInput) Reminder"
                    tasks.insert(TaskItem(title: newChallenge), at: 0)
                    challengeInput = ""
                }
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }

    // Mark task complete
    func markTaskComplete(_ task: TaskItem) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                tasks.remove(at: index)
            }
        }
    }
}

struct TaskItem: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var isCompleted = false
}

#Preview {
    ContentView()
}

