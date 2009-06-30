source $stdenv/setup

header "exporting $url (rev $rev) into $out"

git clone --depth 1 "$url" $out
if test -n "$rev"; then
  cd $out
  git checkout $rev
fi
find $out -name .git\* | xargs rm -rf

stopNest

