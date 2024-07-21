#!/usr/bin/env bash
# Find alleged cherry-picks

set -e

if [ $# != "2" ] ; then
  echo "usage: check-cherry-picks.sh base_rev head_rev"
  exit 2
fi

PICKABLE_BRANCHES=${PICKABLE_BRANCHES:-master staging release-??.?? staging-??.??}
problem=0

while read new_commit_sha ; do
  if [ -z "$new_commit_sha" ] ; then
    continue  # skip empty lines
  fi
  if [ "$GITHUB_ACTIONS" = 'true' ] ; then
    echo "::group::Commit $new_commit_sha"
  else
    echo "================================================="
  fi
  git rev-list --max-count=1 --format=medium "$new_commit_sha"
  echo "-------------------------------------------------"

  original_commit_sha=$(
    git rev-list --max-count=1 --format=format:%B "$new_commit_sha" \
    | grep -Ei -m1 "cherry.*[0-9a-f]{40}" \
    | grep -Eoi -m1 '[0-9a-f]{40}'
  )
  if [ "$?" != "0" ] ; then
    echo "  ? Couldn't locate original commit hash in message"
    [ "$GITHUB_ACTIONS" = 'true' ] && echo ::endgroup::
    continue
  fi

  set -f # prevent pathname expansion of patterns
  for branch_pattern in $PICKABLE_BRANCHES ; do
    set +f # re-enable pathname expansion

    while read -r picked_branch ; do
      if git merge-base --is-ancestor "$original_commit_sha" "$picked_branch" ; then
        echo "  ✔ $original_commit_sha present in branch $picked_branch"

        range_diff_common='git range-diff
          --no-notes
          --creation-factor=100
          '"$original_commit_sha~..$original_commit_sha"'
          '"$new_commit_sha~..$new_commit_sha"'
        '

        if $range_diff_common --no-color | grep -E '^ {4}[+-]{2}' > /dev/null ; then
          if [ "$GITHUB_ACTIONS" = 'true' ] ; then
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
          [ "$GITHUB_ACTIONS" = 'true' ] && echo ::endgroup::
        fi

        # move on to next commit
        continue 3
      fi
    done <<< "$(
      git for-each-ref \
      --format="%(refname)" \
      "refs/remotes/origin/$branch_pattern"
    )"
  done

  if [ "$GITHUB_ACTIONS" = 'true' ] ; then
    echo ::endgroup::
    echo -n "::error ::"
  else
    echo -n "  ✘ "
  fi
  echo "$original_commit_sha not found in any pickable branch"

  problem=1
done <<< "$(
  git rev-list \
    -E -i --grep="cherry.*[0-9a-f]{40}" --reverse \
    "$1..$2"
)"

exit $problem
