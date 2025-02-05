#!/usr/bin/env bash
set -euo pipefail

if (( $# < 1 )); then
    echo "Usage: $0 TARGET_BRANCH"
    echo ""
    echo "TARGET_BRANCH: Branch to rebase the current branch onto, e.g. master or release-24.11"
    exit 1
fi

targetBranch=$1

# Loop through all autorebase-able commits in .git-blame-ignore-revs on the base branch
readarray -t autoLines < <(
  git show "$targetBranch":.git-blame-ignore-revs \
      | sed -n 's/^\([0-9a-f]\+\).*!autorebase \(.*\)$/\1 \2/p'
)
for line in "${autoLines[@]}"; do
    read -r autoCommit autoCmd <<< "$line"

    if ! git cat-file -e "$autoCommit"; then
        echo "Not a valid commit: $autoCommit"
        exit 1
    elif git merge-base --is-ancestor "$autoCommit" HEAD; then
        # Skip commits that we have already
        continue
    fi

    echo -e "\e[32mAuto-rebasing commit $autoCommit with command '$autoCmd'\e[0m"

    # The commit before the commit
    parent=$(git rev-parse "$autoCommit"~)

    echo "Rebasing on top of the previous commit, might need to manually resolve conflicts"
    if ! git rebase --onto "$parent" "$(git merge-base "$targetBranch" HEAD)"; then
      echo -e "\e[33m\e[1mRestart this script after resolving the merge conflict as described above\e[0m"
      exit 1
    fi

    echo "Reapplying the commit on each commit of our branch"
    # This does two things:
    # - The parent filter inserts the auto commit between its parent and
    #   and our first commit. By itself, this causes our first commit to
    #   effectively "undo" the auto commit, since the tree of our first
    #   commit is unchanged. This is why the following is also necessary:
    # - The tree filter runs the command on each of our own commits,
    #   effectively reapplying it.
    FILTER_BRANCH_SQUELCH_WARNING=1 git filter-branch \
        --parent-filter "sed 's/$parent/$autoCommit/'" \
        --tree-filter "$autoCmd" \
        "$autoCommit"..HEAD

    # A tempting alternative is something along the lines of
    #   git rebase --strategy-option=theirs --onto "$rev" "$parent" \
    #     --exec '$autoCmd && git commit --all --amend --no-edit' \
    # but this causes problems because merges are not guaranteed to maintain the formatting.
    # The ./test.sh exercises such a case.
done

echo "Rebasing on top of the latest target branch commit"
git rebase --onto "$targetBranch" "$(git merge-base "$targetBranch" HEAD)"
