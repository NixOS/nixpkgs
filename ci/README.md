# CI support files

This directory contains files to support CI, such as [GitHub Actions](https://github.com/NixOS/nixpkgs/tree/master/.github/workflows) and [Ofborg](https://github.com/nixos/ofborg).
This is in contrast with [`maintainers/scripts`](../maintainers/scripts) which is for human use instead.

## Pinned Nixpkgs

CI may need certain packages from Nixpkgs.
In order to ensure that the needed packages are generally available without building, [`pinned.json`](./pinned.json) contains a pinned Nixpkgs version tested by Hydra.

Run [`update-pinned.sh`](./update-pinned.sh) to update it.

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
