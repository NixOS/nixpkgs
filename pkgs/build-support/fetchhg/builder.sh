source $stdenv/setup
header "getting $url${tag:+ ($tag)} into $out"

hg clone --insecure "$url" hg-clone

hg archive -q -y ${tag:+-r "$tag"} --cwd hg-clone $out
rm -f $out/.hg_archival.txt

stopNest
