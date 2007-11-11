source $stdenv/setup

if test -z "$tag"; then
  tag="-DNOW"
fi
# creating the export drictory and checking out there only to be able to
# move the content without the root directory into $out ...
# cvs -f -d "$url" export $tag -d "$out" "$module"
# should work (but didn't - got no response on #cvs)
# See als man Page for those options

ensureDir $out export
cd export; cvs -f -d "$url" export $tag "$module"
mv */* $out

stopNest
