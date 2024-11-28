#!/usr/bin/env bash

# Check that a PR doesn't include commits from other development branches.
# Fails with next steps if it does

set -euo pipefail
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' exit
SCRIPT_DIR=$(dirname "$0")

log() {
    echo "$@" >&2
}

# Small helper to check whether an element is in a list
# Usage: `elementIn foo "${list[@]}"`
elementIn() {
    local e match=$1
    shift
    for e; do
        if [[ "$e" == "$match" ]]; then
            return 0
        fi
    done
    return 1
}

if (( $# < 6 )); then
    log "Usage: $0 LOCAL_REPO HEAD_REF BASE_REPO BASE_BRANCH PR_REPO PR_BRANCH"
    exit 1
fi
localRepo=$1
headRef=$2
baseRepo=$3
baseBranch=$4
prRepo=$5
prBranch=$6

# All development branches
devBranchPatterns=()
while read -r pattern; do
    if [[ "$pattern" != '#'* ]]; then
        devBranchPatterns+=("$pattern")
    fi
done < "$SCRIPT_DIR/dev-branches.txt"

git -C "$localRepo" branch --list --format "%(refname:short)" "${devBranchPatterns[@]}" > "$tmp/dev-branches"
readarray -t devBranches < "$tmp/dev-branches"

if [[ "$baseRepo" == "$prRepo" ]] && elementIn "$prBranch" "${devBranches[@]}"; then
    log "This PR merges $prBranch into $baseBranch, no commit check necessary"
    exit 0
fi

# The current merge base of the PR
prMergeBase=$(git -C "$localRepo" merge-base "$baseBranch" "$headRef")
log "The PR's merge base with the base branch $baseBranch is $prMergeBase"

# This is purely for debugging
git -C "$localRepo" rev-list --reverse "$baseBranch".."$headRef" > "$tmp/pr-commits"
log "The PR includes these $(wc -l < "$tmp/pr-commits") commits:"
cat <"$tmp/pr-commits" >&2

for testBranch in "${devBranches[@]}"; do

    if [[ -z "$(git -C "$localRepo" rev-list -1 --since="1 month ago" "$testBranch")" ]]; then
        log "Not checking $testBranch, was inactive for the last month"
        continue
    fi
    log "Checking if commits from $testBranch are included in the PR"

    # We need to check for any commits that are in the PR which are also in the test branch.
    # We could check each commit from the PR individually, but that's unnecessarily slow.
    #
    # This does _almost_ what we want: `git rev-list --count headRef testBranch ^baseBranch`,
    # except that it includes commits that are reachable from _either_ headRef or testBranch,
    # instead of restricting it to ones reachable by both

    # Easily fixable though, because we can use `git merge-base testBranch headRef`
    # to get the least common ancestor (aka merge base) commit reachable by both.
    # If the branch being tested is indeed the right base branch,
    # this is then also the commit from that branch that the PR is based on top of.
    testMergeBase=$(git -C "$localRepo" merge-base "$testBranch" "$headRef")

    # And then use the `git rev-list --count`, but replacing the non-working
    # `headRef testBranch` with the merge base of the two.
    extraCommits=$(git -C "$localRepo" rev-list --count "$testMergeBase" ^"$baseBranch")

    if (( extraCommits != 0 )); then
        log -e "\e[33m"
        echo "The PR's base branch is set to $baseBranch, but $extraCommits commits from the $testBranch branch are included. Make sure you know the [right base branch for your changes](https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#branch-conventions), then:"
        echo "- If the changes should go to the $testBranch branch, [change the base branch](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/changing-the-base-branch-of-a-pull-request) to $testBranch"
        echo "- If the changes should go to the $baseBranch branch, rebase your PR onto the merge base with the $baseBranch branch:"
        echo "  \`\`\`bash"
        echo "  # git rebase --onto \$(git merge-base upstream/$baseBranch HEAD) \$(git merge-base upstream/$testBranch HEAD)"
        echo "  git rebase --onto $prMergeBase $testMergeBase"
        echo "  git push --force-with-lease"
        echo "  \`\`\`"
        log -e "\e[m"
        exit 1
    fi
done

log "Base branch is correct, no commits from development branches are included"
