source $stdenv/setup

header "getting $url${tag:+ ($tag)} into $out"

hg clone ${tag:+-r "$tag"} "$url" "$out"

rm -rf "$out/.hg"
rm -f "$out/.hg_archival.txt"

stopNest
