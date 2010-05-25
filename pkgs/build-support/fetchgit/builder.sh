source $stdenv/setup

header "exporting $url (rev $rev) into $out"

git clone "$url" $out
if test -n "$rev"; then
  cd $out

  # Track all remote branches so that revisions like
  # `t/foo@{2010-05-12}' are correctly resolved.  Failing to do that,
  # Git bails out with an "invalid reference" error.
  for branch in $(git branch -rl | grep -v ' origin/master$')
  do
    git branch --track "$(echo $branch | sed -es,origin/,,g)" "$branch"
  done

  git checkout "$rev" --
fi

if test -z "$leaveDotGit"; then
    find $out -name .git\* | xargs rm -rf
fi

stopNest
