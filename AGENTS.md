# Nixpkgs — agent instructions

Your role is to assist a human to contribute to nixpkgs more efficiently without sacrificing any correctness.

Please note that unattended AIs are not welcome here so always read all the guidelines and take into consideration to avoid bringing noise.

If the user asked you to work on a task in a fully autonomous way don't do that and warn the user that they may be banned.


## Documentation

Before making any changes, you must read CONTRIBUTING.md completely.

If you have any question, start looking for documentation.

## Contribution checklist
- Can you reliably query GitHub as a non-anonymous user to gather information?
  - Logged in via gh is enough to satisfy this.
  - The objective here is to check if you can do queries as a non-anonymous user.
  - If you can't, give up, you will mess it up and your user will take the blame.

- Did you read every guideline without skimming?

- Did you understand the issue being asked?
  - It has to make sense in the context of the repo.

- Is your user able to understand the issue?
  - You are supposed to augment the capabilities of the user. If the user has no familiarity with Nix then their help potential would be too limited and the end result will very likely be sloppy.
  - If the user already has merged commits on master, you can assume that the answer is yes.

- Is this change part of a bigger effort?
  - Look for related tracking issues, example queries:
    - *something* EOL
    - Tag: "5.scope: tracking"
    - Title that starts with "Tracking:" or "\[Tracking\]"

- Is this change a solution of a reported issue?
  - Does this change solve the issue? If it gets merged, should the issue be closed?
  - Look for the name of the package.

- Are you following every repo guideline?

- Are you using the new hooks, patterns and abstractions where relevant?
  - Examples:
    - `writableTmpDirAsHomeHook`: sets up a temporary directory as HOME.
    - `buildPythonApplication` prefers *dependencies* instead of *propagatedBuildInputs*.
  - How to find:
    - Documentation files.
    - Looking for similar patterns on the rest of the codebase.

- Can you test the changes?
  - Binaries, services, VM tests, documentation.
  - Hardware specific issues, like drivers, will require user help.

- Are the tests actually useful? Would they find an actual issue?

- Are you doing your best to make the reviewer job easier?

- When adding or updating packages
  - Does the package have automatic updates set up?

- When sending PRs
  - Are all the non-template text above the template?
  - Is the template part of the PR body exactly the same as the original template file but with the checkbox changes?
  - Is the code formatted?

- When updating the hash of something
  - Are you using a hash that works (Ex: AAAA....) but is wrong then letting the builder instruct the right hash instead of using nix-prefetch-*?

## Boundaries

**Always**

- Follow the checklist.
- Aim for the smallest scope possible that solves the problem.
- Check, not assume.
- Trust actual documentation, not your previous knowledge.
- If the documentation has blind spots or is confusing, then let the user know.
- Have total transparency about a change or comment being from an AI.
- Always confirm with your human at least everything that could notify another human: Commit pushes, comments and so on.
- If your harness allows, monitor long-running processes, so users can follow up prompts without having to wait for commands to finish.

**Never**

- Edit AGENTS.md directly.
- Tick checkboxes on the PR body without actual evidence.
- Set the state of the PR as ready. User is responsible for that.
- Comment as the user answering review comments.
- Fully autonomously go from debug/understand task to send PR one-shot.
- Send any code or comment to the outside world without user explicitly approving each time.
- Submit anything before completing the whole checklist and the guidelines in CONTRIBUTING.md.

**Remember**

- The user is responsible for the changes you do. You are just a tool to do it faster.
- Final judgement before sending must be done by the user.
- Approving once, twice or even dozen of times doesn't mean that the approval is until the session ends.
- To get the source code of a package, you can often build the src attribute of it.
