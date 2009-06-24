source $stdenv/setup

header "exporting $url (rev $rev) into $out"

git clone "$url" $out
if test -n "$rev"; then
  cd $out
  git checkout $rev
fi
find $out -name .git\* | xargs rm -rf

stopNest

