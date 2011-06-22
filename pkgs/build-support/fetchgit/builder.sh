# tested so far with:
# - no revision specified and remote has a HEAD which is used
# - revision specified and remote has a HEAD
source $stdenv/setup

header "exporting $url (rev $rev) into $out"

git init $out
cd $out
git remote add origin "$url"
git fetch origin
git remote set-head origin -a || (
    test -n $rev && echo "that's ok, we want $rev" || exit 1)

if test -n "$rev"; then
    echo "Trying to checkout: $rev"
    parsed_rev=$(
        git rev-parse --verify "$rev" 2>/dev/null ||
        git rev-parse --verify origin/"$rev" 2>/dev/null
    ) 
    git reset --hard $parsed_rev
    git checkout -b __nixos_build__
else
    git checkout -b __nixos_build__ origin/HEAD
fi

if test -z "$leaveDotGit"; then
    find $out -name .git\* | xargs rm -rf
fi

stopNest
