source $stdenv/setup

header "getting $url${tag:+ ($tag)} into $out"

hg clone ${tag:+-r "$tag"} "$url" "$out"

rm -rf "$out/.hg"

stopNest
