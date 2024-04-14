#! /usr/bin/env nix-shell
#! nix-shell -i bash -p git gh -I nixpkgs=.
#
# Script to merge the currently open haskell-updates PR into master, bump the
# Stackage version and Hackage versions, and open the next haskell-updates PR.

set -eu -o pipefail

# exit after printing first argument to this function
function die {
  # echo the first argument
  echo "ERROR: $1"
  echo "Aborting!"

  exit 1
}

function help {
  echo "Usage: $0 HASKELL_UPDATES_PR_NUM"
  echo "Merge the currently open haskell-updates PR into master, and open the next one."
  echo
  echo "  -h, --help                print this help"
  echo "  HASKELL_UPDATES_PR_NUM    number of the currently open PR on NixOS/nixpkgs"
  echo "                            for the haskell-updates branch"
  echo
  echo "Example:"
  echo "  \$ $0 137340"

  exit 1
}

# Read in the current haskell-updates PR number from the command line.
while [[ $# -gt 0 ]]; do
  key="$1"

  case $key in
    -h|--help)
      help
      ;;
    *)
      curr_haskell_updates_pr_num="$1"
      shift
      ;;
  esac
done

if [[ -z "${curr_haskell_updates_pr_num-}" ]] ; then
  die "You must pass the current haskell-updates PR number as the first argument to this script."
fi

# Make sure you have gh authentication setup.
if ! gh auth status 2>/dev/null ; then
  die "You must setup the \`gh\` command.  Run \`gh auth login\`."
fi

# Make sure this is configured before we start doing anything
push_remote="$(git config branch.haskell-updates.pushRemote)" \
  || die 'Can'\''t determine pushRemote for haskell-updates. Please set using `git config branch.haskell-updates.pushremote <remote name>`.'

# Fetch nixpkgs to get an up-to-date origin/haskell-updates branch.
echo "Fetching origin..."
git fetch origin >/dev/null

# Make sure we are currently on a local haskell-updates branch.
curr_branch="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$curr_branch" != "haskell-updates" ]]; then
    die "Current branch is not called \"haskell-updates\"."
fi

# Make sure our local haskell-updates branch is on the same commit as
# origin/haskell-updates.
curr_branch_commit="$(git rev-parse haskell-updates)"
origin_haskell_updates_commit="$(git rev-parse origin/haskell-updates)"
if [[ "$curr_branch_commit" != "$origin_haskell_updates_commit" ]]; then
    die "Current branch is not at the same commit as origin/haskell-updates"
fi

# Merge the current open haskell-updates PR.
echo "Merging https://github.com/NixOS/nixpkgs/pull/${curr_haskell_updates_pr_num}..."
gh pr merge --repo NixOS/nixpkgs --merge "$curr_haskell_updates_pr_num"

# Update the list of Haskell package versions in NixOS on Hackage.
echo "Updating list of Haskell package versions in NixOS on Hackage..."
./maintainers/scripts/haskell/upload-nixos-package-list-to-hackage.sh

# Update stackage, Hackage hashes, and regenerate Haskell package set
echo "Updating Stackage..."
./maintainers/scripts/haskell/update-stackage.sh --do-commit
echo "Updating Hackage hashes..."
./maintainers/scripts/haskell/update-hackage.sh --do-commit
echo "Regenerating Hackage packages..."
# Using fast here because after the hackage-update eval errors will likely break the transitive dependencies check.
./maintainers/scripts/haskell/regenerate-hackage-packages.sh --fast --do-commit

# Push these new commits to the haskell-updates branch
echo "Pushing commits just created to the remote $push_remote/haskell-updates branch..."
git push "$push_remote" haskell-updates

# Open new PR
new_pr_body=$(cat <<EOF
### This Merge

This PR is the regular merge of the \`haskell-updates\` branch into \`master\`.

This branch is being continually built and tested by hydra at https://hydra.nixos.org/jobset/nixpkgs/haskell-updates. You may be able to find an up-to-date Hydra build report at [cdepillabout/nix-haskell-updates-status](https://github.com/cdepillabout/nix-haskell-updates-status).

We roughly aim to merge these \`haskell-updates\` PRs at least once every two weeks. See the @NixOS/haskell [team calendar](https://cloud.maralorn.de/apps/calendar/p/H6migHmKX7xHoTFa) for who is currently in charge of this branch.

### haskellPackages Workflow Summary

Our workflow is currently described in [\`pkgs/development/haskell-modules/HACKING.md\`](https://github.com/NixOS/nixpkgs/blob/haskell-updates/pkgs/development/haskell-modules/HACKING.md).

The short version is this:
* We regularly update the Stackage and Hackage pins on \`haskell-updates\` (normally at the beginning of a merge window).
* The community fixes builds of Haskell packages on that branch.
* We aim at at least one merge of \`haskell-updates\` into \`master\` every two weeks.
* We only do the merge if the [\`mergeable\`](https://hydra.nixos.org/job/nixpkgs/haskell-updates/mergeable) job is succeeding on hydra.
* If a [\`maintained\`](https://hydra.nixos.org/job/nixpkgs/haskell-updates/maintained) package is still broken at the time of merge, we will only merge if the maintainer has been pinged 7 days in advance. (If you care about a Haskell package, become a maintainer!)

More information about Haskell packages in nixpkgs can be found [in the nixpkgs manual](https://nixos.org/manual/nixpkgs/unstable/#haskell).

---

This is the follow-up to #${curr_haskell_updates_pr_num}. Come to [#haskell:nixos.org](https://matrix.to/#/#haskell:nixos.org) if you have any questions.
EOF
)

echo "Opening a PR for the next haskell-updates merge cycle..."
gh pr create --repo NixOS/nixpkgs --base master --head haskell-updates --title "haskellPackages: update stackage and hackage" --body "$new_pr_body"
