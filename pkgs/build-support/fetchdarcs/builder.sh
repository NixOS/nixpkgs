source $stdenv/setup

tagtext=""
tagflags=""
if test -n "$tag"; then
    tagtext="(tag $tag) "
    tagflags="--tag=$tag"
fi

header "getting $url ${tagtext}into $out"

darcs get --no-pristine-tree --partial $tagflags "$url" "$out"
# remove metadata, because it can change
rm -rf "$out/_darcs"

stopNest
