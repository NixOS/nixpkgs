# CI support files

This directory contains files to support CI, such as [GitHub Actions](https://github.com/NixOS/nixpkgs/tree/master/.github/workflows) and [Ofborg](https://github.com/nixos/ofborg).
This is in contrast with [`maintainers/scripts`](../maintainers/scripts) which is for human use instead.

## Pinned Nixpkgs

CI may need certain packages from Nixpkgs.
In order to ensure that the needed packages are generally available without building,
[`pinned-nixpkgs.json`](./pinned-nixpkgs.json) contains a pinned Nixpkgs version tested by Hydra.

Run [`update-pinned-nixpkgs.sh`](./update-pinned-nixpkgs.sh) to update it.

## `ci/nixpkgs-vet.sh BASE_BRANCH [REPOSITORY]`

Runs the [`nixpkgs-vet` tool](https://github.com/NixOS/nixpkgs-vet) on the HEAD commit, closely matching what CI does. This can't do exactly the same as CI, because CI needs to rely on GitHub's server-side Git history to compute the mergeability of PRs before the check can be started.
In turn, when contributors are running this tool locally, we don't want to have to push commits to test them, and we can also rely on the local Git history to do the mergeability check.

Arguments:

- `BASE_BRANCH`: The base branch to use, e.g. master or release-24.05
- `REPOSITORY`: The repository from which to fetch the base branch. Defaults to <https://github.com/NixOS/nixpkgs.git>.

## `ci/nixpkgs-vet`

This directory contains scripts and files used and related to [`nixpkgs-vet`](https://github.com/NixOS/nixpkgs-vet/), which the CI uses to implement `pkgs/by-name` checks, along with many other Nixpkgs architecture rules.
See also the [CI GitHub Action](../.github/workflows/nixpkgs-vet.yml).

## `ci/nixpkgs-vet/update-pinned-tool.sh`

Updates the pinned [`nixpkgs-vet` tool](https://github.com/NixOS/nixpkgs-vet) in [`ci/nixpkgs-vet/pinned-version.txt`](./nixpkgs-vet/pinned-version.txt) to the latest [release](https://github.com/NixOS/nixpkgs-vet/releases).

Each release contains a pre-built `x86_64-linux` version of the tool which is used by CI.

This script currently needs to be called manually when the CI tooling needs to be updated.

Why not just build the tooling right from the PRs Nixpkgs version?

- Because it allows CI to check all PRs, even if they would break the CI tooling.
- Because it makes the CI check very fast, since no Nix builds need to be done, even for mass rebuilds.
- Because it improves security, since we don't have to build potentially untrusted code from PRs.
  The tool only needs a very minimal Nix evaluation at runtime, which can work with [readonly-mode](https://nixos.org/manual/nix/stable/command-ref/opt-common.html#opt-readonly-mode) and [restrict-eval](https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-restrict-eval).

## `get-merge-commit.sh GITHUB_REPO PR_NUMBER`

Check whether a PR is mergeable and return the test merge commit as
[computed by GitHub](https://docs.github.com/en/rest/guides/using-the-rest-api-to-interact-with-your-git-database?apiVersion=2022-11-28#checking-mergeability-of-pull-requests).

Arguments:
- `GITHUB_REPO`: The repository of the PR, e.g. `NixOS/nixpkgs`
- `PR_NUMBER`: The PR number, e.g. `1234`

Exit codes:
- 0: The PR can be merged, the test merge commit hash is returned on stdout
- 1: The PR cannot be merged because it's not open anymore
- 2: The PR cannot be merged because it has a merge conflict
- 3: The merge commit isn't being computed, GitHub is likely having internal issues, unknown if the PR is mergeable

### Usage

This script is implemented as a reusable GitHub Actions workflow, and can be used as follows:

```yaml
on: pull_request_target

# We need a token to query the API, but it doesn't need any special permissions
permissions: {}

jobs:
  get-merge-commit:
    # use the relative path of the get-merge-commit workflow yaml here
    uses: ./.github/workflows/get-merge-commit.yml

  build:
    name: Build
    runs-on: ubuntu-latest
    needs: get-merge-commit
    steps:
      - uses: actions/checkout@<VERSION>
        # Add this to _all_ subsequent steps to skip them
        if: needs.get-merge-commit.outputs.mergedSha
        with:
          ref: ${{ needs.get-merge-commit.outputs.mergedSha }}
      - ...
```
