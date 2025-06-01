#!/usr/bin/env bash
# Find alleged cherry-picks

set -euo pipefail

if [[ $# != "2" && $# != "3" ]] ; then
  echo "usage: check-cherry-picks.sh base_rev head_rev [markdown_file]"
  exit 2
fi

markdown_file="$(realpath ${3:-/dev/null})"
[ -v 3 ] && rm -f "$markdown_file"

# Make sure we are inside the nixpkgs repo, even when called from outside
cd "$(dirname "${BASH_SOURCE[0]}")"

PICKABLE_BRANCHES="master staging release-??.?? staging-??.?? haskell-updates python-updates staging-next staging-next-??.??"
problem=0

# Not everyone calls their remote "origin"
remote="$(git remote -v | grep -i 'NixOS/nixpkgs' | head -n1 | cut -f1 || true)"

commits="$(git rev-list --reverse "$1..$2")"

log() {
  type="$1"
  shift 1

  local -A prefix
  prefix[success]="  ✔ "
  if [ -v GITHUB_ACTIONS ]; then
    prefix[warning]="::warning::"
    prefix[error]="::error::"
  else
    prefix[warning]="  ⚠ "
    prefix[error]="  ✘ "
  fi

  echo "${prefix[$type]}$@"

  # Only logging errors and warnings, which allows comparing the markdown file
  # between pushes to the PR. Even if a new, proper cherry-pick, commit is added
  # it won't change the markdown file's content and thus not trigger another comment.
  if [ "$type" != "success" ]; then
    local -A alert
    alert[warning]="WARNING"
    alert[error]="CAUTION"
    echo >> $markdown_file
    echo "> [!${alert[$type]}]" >> $markdown_file
    echo "> $@" >> $markdown_file
  fi
}

endgroup() {
  if [ -v GITHUB_ACTIONS ] ; then
    echo ::endgroup::
  fi
}

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
    endgroup
    log warning "Couldn't locate original commit hash in message of $new_commit_sha."
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
        range_diff_common='git --no-pager range-diff
          --no-notes
          --creation-factor=100
          '"$original_commit_sha~..$original_commit_sha"'
          '"$new_commit_sha~..$new_commit_sha"'
        '

        if $range_diff_common --no-color 2> /dev/null | grep -E '^ {4}[+-]{2}' > /dev/null ; then
          log success "$original_commit_sha present in branch $picked_branch"
          endgroup
          log warning "Difference between $new_commit_sha and original $original_commit_sha may warrant inspection."

          # First line contains commit SHAs, which we already printed.
          $range_diff_common --color | tail -n +2

          echo -e "> <details><summary>Show diff</summary>\n>" >> $markdown_file
          echo '> ```diff' >> $markdown_file
          # The output of `git range-diff` is indented with 4 spaces, which we need to match with the
          # code blocks indent to get proper syntax highlighting on GitHub.
          diff="$($range_diff_common | tail -n +2 | sed -Ee 's/^ {4}/> /g')"
          # Also limit the output to 10k bytes (and remove the last, potentially incomplete line), because
          # GitHub comments are limited in length. The value of 10k is arbitrary with the assumption, that
          # after the range-diff becomes a certain size, a reviewer is better off reviewing the regular diff
          # in GitHub's UI anyway, thus treating the commit as "new" and not cherry-picked.
          # Note: This could still lead to a too lengthy comment with multiple commits touching the limit. We
          # consider this too unlikely to happen, to deal with explicitly.
          max_length=10000
          if [ "${#diff}" -gt $max_length ]; then
            printf -v diff "%s\n\n[...truncated...]" "$(echo "$diff" | head -c $max_length | head -n-1)"
          fi
          echo "$diff" >> $markdown_file
          echo '> ```' >> $markdown_file
          echo "> </details>" >> $markdown_file

          problem=1
        else
          log success "$original_commit_sha present in branch $picked_branch"
          log success "$original_commit_sha highly similar to $new_commit_sha"
          $range_diff_common --color
          endgroup
        fi

        # move on to next commit
        continue 3
      fi
    done <<< "$branches"
  done

  endgroup
  log error "$original_commit_sha given in $new_commit_sha not found in any pickable branch."

  problem=1
done <<< "$commits"

exit $problem
