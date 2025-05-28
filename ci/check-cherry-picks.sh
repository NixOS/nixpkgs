#!/usr/bin/env bash
# Find alleged cherry-picks

set -euo pipefail

if [ $# != "2" ] ; then
  echo "usage: check-cherry-picks.sh base_rev head_rev"
  exit 2
fi

# Make sure we are inside the nixpkgs repo, even when called from outside
cd "$(dirname "${BASH_SOURCE[0]}")"

PICKABLE_BRANCHES="master staging release-??.?? staging-??.?? haskell-updates python-updates staging-next staging-next-??.??"
problem=0

# Not everyone calls their remote "origin"
remote="$(git remote -v | grep -i 'NixOS/nixpkgs' | head -n1 | cut -f1 || true)"

commits="$(git rev-list --reverse "$1..$2")"

while read -r new_commit_sha ; do
  if [ -v GITHUB_ACTIONS ] ; then
    echo "::group::Commit $new_commit_sha"
  else
    echo "================================================="
  fi
  git rev-list --max-count=1 --format=medium "$new_commit_sha"
  echo "-------------------------------------------------"

  original_commit_sha=$(
    git rev-list --max-count=1 --format=format:%B "$new_commit_sha" \
    | grep -Ei -m1 "cherry.*[0-9a-f]{40}" \
    | grep -Eoi -m1 '[0-9a-f]{40}' || true
  )
  if [ -z "$original_commit_sha" ] ; then
    if [ -v GITHUB_ACTIONS ] ; then
      echo ::endgroup::
      echo -n "::error ::"
    else
      echo -n "  ✘ "
    fi
    echo "Couldn't locate original commit hash in message"
    echo "Note this should not necessarily be treated as a hard fail, but a reviewer's attention should" \
      "be drawn to it and github actions have no way of doing that but to raise a 'failure'"
    problem=1
    continue
  fi

  set -f # prevent pathname expansion of patterns
  for pattern in $PICKABLE_BRANCHES ; do
    set +f # re-enable pathname expansion

    # Reverse sorting by refname and taking one match only means we can only backport
    # from unstable and the latest stable. That makes sense, because even right after
    # branch-off, when we have two supported stable branches, we only ever want to cherry-pick
    # **to** the older one, but never **from** it.
    # This makes the job significantly faster in the case when commits can't be found,
    # because it doesn't need to iterate through 20+ branches, which all need to be fetched.
    branches="$(git for-each-ref --sort=-refname --format="%(refname)" \
      "refs/remotes/${remote:-origin}/$pattern" | head -n1)"

    while read -r picked_branch ; do
      if git merge-base --is-ancestor "$original_commit_sha" "$picked_branch" ; then
        echo "  ✔ $original_commit_sha present in branch $picked_branch"

        range_diff_common='git --no-pager range-diff
          --no-notes
          --creation-factor=100
          '"$original_commit_sha~..$original_commit_sha"'
          '"$new_commit_sha~..$new_commit_sha"'
        '

        if $range_diff_common --no-color 2> /dev/null | grep -E '^ {4}[+-]{2}' > /dev/null ; then
          if [ -v GITHUB_ACTIONS ] ; then
            echo ::endgroup::
            echo -n "::warning ::"
          else
            echo -n "  ⚠ "
          fi
          echo "Difference between $new_commit_sha and original $original_commit_sha may warrant inspection:"

          $range_diff_common --color

          echo "Note this should not necessarily be treated as a hard fail, but a reviewer's attention should" \
            "be drawn to it and github actions have no way of doing that but to raise a 'failure'"
          problem=1
        else
          echo "  ✔ $original_commit_sha highly similar to $new_commit_sha"
          $range_diff_common --color
          [ -v GITHUB_ACTIONS ] && echo ::endgroup::
        fi

        # move on to next commit
        continue 3
      fi
    done <<< "$branches"
  done

  if [ -v GITHUB_ACTIONS ] ; then
    echo ::endgroup::
    echo -n "::error ::"
  else
    echo -n "  ✘ "
  fi
  echo "$original_commit_sha not found in any pickable branch"

  problem=1
done <<< "$commits"

exit $problem
