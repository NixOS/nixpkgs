# GitHub Actions Workflows

Some architectural notes about key decisions and concepts in our workflows:

- Instead of `pull_request` we use [`pull_request_target`](https://docs.github.com/actions/writing-workflows/choosing-when-your-workflow-runs/events-that-trigger-workflows#pull_request_target) for all PR-related workflows.
  This has the advantage that those workflows will run without prior approval for external contributors.

- Running on `pull_request_target` also optionally provides us with a GH_TOKEN with elevated privileges (write access), which we need to do things like adding labels, requesting reviewers or pushing branches.
  **Note about security:** We need to be careful to limit the scope of elevated privileges as much as possible.
  Thus they should be lowered to the minimum with `permissions: {}` in every workflow by default.

- By definition `pull_request_target` runs in the context of the **base** of the pull request.
  This means, that the workflow files to run will be taken from the base branch, not the PR, and actions/checkout will not checkout the PR, but the base branch, by default.
  To protect our secrets, we need to make sure to **never execute code** from the pull request and always evaluate or build nix code from the pull request with the **sandbox enabled**.

- To test the pull request's contents, we checkout the "test merge commit".
  This is a temporary commit that GitHub creates automatically as "what would happen, if this PR was merged into the base branch now?".
  The checkout could be done via the virtual branch `refs/pull/<pr-number>/merge`, but doing so would cause failures when this virtual branch doesn't exist (anymore).
  This can happen when the PR has conflicts, in which case the virtual branch is not created, or when the PR is getting merged while workflows are still running, in which case the branch won't exist anymore at the time of checkout.
  Thus, we use the `prepare` job to check whether the PR is mergeable and the test merge commit exists and only then run the relevant jobs.

- Various workflows need to make comparisons against the base branch.
  In this case, we checkout the parent of the "test merge commit" for best results.
  Note, that this is not necessarily the same as the default commit that actions/checkout would use, which is also a commit from the base branch (see above), but might be older.

## Terminology

- **base commit**: The pull_request_target event's context commit, i.e. the base commit given by GitHub Actions.
  Same as `github.event.pull_request.base.sha`.
- **head commit**: The HEAD commit in the pull request's branch.
  Same as `github.event.pull_request.head.sha`.
- **merge commit**: The temporary "test merge commit" that GitHub Actions creates and updates for the pull request.
  Same as `refs/pull/${{ github.event.pull_request.number }}/merge`.
- **target commit**: The base branch's parent of the "test merge commit" to compare against.

## Concurrency Groups

We use [GitHub's Concurrency Groups](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/control-the-concurrency-of-workflows-and-jobs) to cancel older jobs on pushes to Pull Requests.
When two workflows are in the same group, a newer workflow cancels an older workflow.
Thus, it is important how to construct the group keys:

- Because we want to run jobs for different events at same time, we add `github.event_name` to the key.
  This is the case for the `pull_request` which runs on changes to the workflow files to test the new files and the same workflow from the base branch run via `pull_request_event`.

- We don't want workflows of different Pull Requests to cancel each other, so we include `github.event.pull_request.number`.
  The [GitHub docs](https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/control-the-concurrency-of-workflows-and-jobs#example-using-a-fallback-value) show using `github.head_ref` for this purpose, but this doesn't work well with forks: Different users could have the same head branch name in their forks and run CI for their PRs at the same time.

- Sometimes, there is no `pull_request.number`.
  To ensure non-PR runs are never cancelled, we add a fallback of `github.run_id`.
  This is a unique value for each workflow run.

- Of course, we run multiple workflows at the same time, so we add `github.workflow` to the key.
  Otherwise workflows would cancel each other.

- There is a special case for reusable workflows called via `workflow_call` - they will have `github.workflow` set to their parent workflow's name.
  Thus, they would cancel each other.
  That's why we additionally hardcode the name of the workflow as well.

This results in a key with the following semantics:

```
<running-workflow>-<triggering-workflow>-<triggered-event>-<pull-request/fallback>
```

## Required Status Checks

The "Required Status Checks" branch ruleset is implemented in two top-level workflows: `pr.yml` and `merge-group.yml`.

The PR workflow defines all checks that need to succeed to add a Pull Request to the Merge Queue.
If no Merge Queue is set up for a branch, the PR workflow defines the checks required to merge into the target branch.

The Merge Group workflow defines all checks that are run as part of the Merge Queue.
Only when these pass, a Pull Request is finally merged into the target branch.
They don't apply when no Merge Queue is set up.

Both workflows work with the same `no PR failures` status check.
This name can never be changed, because it's used in the branch ruleset for these rules.
