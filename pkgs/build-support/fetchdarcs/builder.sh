source $stdenv/setup

tagtext=""
tagflags=""
if test -n "$tag"; then
    tagtext="(tag $tag) "
    tagflags="--tag=$tag"
fi

header "getting $url ${tagtext}into $out"

darcs get --no-pristine-tree $tagflags "$url" "$out"
# remove metadata, because it can change
rm -rf "$out/_darcs"

actual=$(nix-hash $out)
if test "$actual" != "$outputHash"; then
    echo "hash is $actual, expected $outputHash" >&2
    exit 1
fi

stopNest
