# CI support files

This directory contains files to support CI, such as [GitHub Actions](https://github.com/NixOS/nixpkgs/tree/master/.github/workflows) and [Ofborg](https://github.com/nixos/ofborg).
This is in contrast with [`maintainers/scripts`](../maintainers/scripts) which is for human use instead.

## Pinned Nixpkgs

CI may need certain packages from Nixpkgs.
In order to ensure that the needed packages are generally available without building, [`pinned.json`](./pinned.json) contains a pinned Nixpkgs version tested by Hydra.

Run [`update-pinned.sh`](./update-pinned.sh) to update it.

## GitHub specific code

Some of the code is specific to GitHub.
This code is currently spread out over multiple places and written in both Bash and JavaScript.
The goal is to eventually have all GitHub specific code in `ci/github-script` and written in JavaScript via `actions/github-script`.
A lot of code has already been migrated, but some Bash code still remains.
New CI features need to be introduced in JavaScript, not Bash.

## Nixpkgs merge bot

The Nixpkgs merge bot empowers package maintainers by enabling them to merge PRs related to their own packages.
It serves as a bridge for maintainers to quickly respond to user feedback, facilitating a more self-reliant approach.
Especially when considering there are roughly 20 maintainers for every committer, this bot is a game-changer.

Following [RFC 172] the merge bot was originally implemented as a [python webapp](https://github.com/NixOS/nixpkgs-merge-bot), which has now been integrated into [`ci/github-script/bot.js`](./github-script/bot.js) and [`ci/github-script/merge.js`](./github-script/merge.js).

### Using the merge bot

To merge a PR, maintainers can simply comment:
```gfm
@NixOS/nixpkgs-merge-bot merge
```

The next time the bot runs it will verify the below constraints, then (if satisfied) merge the PR.

The merge bot will reference [#306934](https://github.com/NixOS/nixpkgs/issues/306934) on PRs it merges successfully, [#305350](https://github.com/NixOS/nixpkgs/issues/305350) for unsuccessful attempts, or [#371492](https://github.com/NixOS/nixpkgs/issues/371492) if an error occurs.
These issues effectively list PRs the merge bot has interacted with.

### Merge bot constraints

To ensure security and a focused utility, the bot adheres to specific limitations:

- The PR targets one of the [development branches](#branch-classification).
- The PR only touches files of packages located under `pkgs/by-name/*`.
- The PR is either:
  - approved by a [committer][@NixOS/nixpkgs-committers].
  - backported via label.
  - opened by a [committer][@NixOS/nixpkgs-committers].
  - opened by [@r-ryantm](https://nix-community.github.io/nixpkgs-update/r-ryantm/).
- The user attempting to merge is a member of [@NixOS/nixpkgs-maintainers].
- The user attempting to merge is a maintainer of all packages touched by the PR.

### Approving merge bot changes

Changes to the bot can usually be approved by the [@NixOS/nixpkgs-ci] team, as with other CI changes.
However, additional acknowledgement from the [@NixOS/nixpkgs-core] team is required for changes to what the merge bot will merge, who is eligible to use the merge bot, or similar changes in scope.

## `ci/nixpkgs-vet.sh BASE_BRANCH [REPOSITORY]`

Runs the [`nixpkgs-vet` tool](https://github.com/NixOS/nixpkgs-vet) on the HEAD commit, closely matching what CI does.
This can't do exactly the same as CI, because CI needs to rely on GitHub's server-side Git history to compute the mergeability of PRs before the check can be started.
In turn, when contributors are running this tool locally, we don't want to have to push commits to test them, and we can also rely on the local Git history to do the mergeability check.

Arguments:

- `BASE_BRANCH`: The base branch to use, e.g. master or release-24.05
- `REPOSITORY`: The repository from which to fetch the base branch.
  Defaults to <https://github.com/NixOS/nixpkgs.git>.

# Branch classification

For the purposes of CI, branches in the NixOS/nixpkgs repository are classified as follows:

- **Channel** branches
  - `nixos-` or `nixpkgs-` prefix
  - Are only updated from `master` or `release-` branches, when hydra passes.
  - Otherwise not worked on, Pull Requests are not allowed.
  - Long-lived, no deletion, no force push.
- **Primary development** branches
  - `release-` prefix and `master`
  - Pull Requests required.
  - Long-lived, no deletion, no force push.
- **Secondary development** branches
  - `staging-` prefix and `haskell-updates`
  - Pull Requests normally required, except when merging development branches into each other.
  - Long-lived, no deletion, no force push.
- **Work-In-Progress** branches
  - `backport-`, `revert-` and `wip-` prefixes.
  - Deprecated: All other branches, not matched by channel/development.
  - Pull Requests are optional.
  - Short-lived, force push allowed, deleted after merge.

Some branches also have a version component, which is either `unstable` or `YY.MM`.

`ci/supportedBranches.js` is a script imported by CI to classify the base and head branches of a Pull Request.
This classification will then be used to skip certain jobs.
This script can also be run locally to print basic test cases.


[@NixOS/nixpkgs-maintainers]: https://github.com/orgs/NixOS/teams/nixpkgs-maintainers
[@NixOS/nixpkgs-committers]: https://github.com/orgs/NixOS/teams/nixpkgs-committers
[@NixOS/nixpkgs-ci]: https://github.com/orgs/NixOS/teams/nixpkgs-ci
[@NixOS/nixpkgs-core]: https://github.com/orgs/NixOS/teams/nixpkgs-core
[RFC 172]: https://github.com/NixOS/rfcs/pull/172
