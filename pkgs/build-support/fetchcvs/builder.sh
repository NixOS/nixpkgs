source $stdenv/setup

# creating the export drictory and checking out there only to be able to
# move the content without the root directory into $out ...
# cvs -f -d "$url" export $tag -d "$out" "$module"
# should work (but didn't - got no response on #cvs)
# See als man Page for those options

mkdir -p export
if [ -n "$tag" ]; then
    tag="-r $tag"
else
    if [ -n "$date" ]; then
        tag="-D $date"
    else
        tag="-D NOW"
    fi
fi
(cd export && cvs -f -z0 -d "$cvsRoot" export $tag "$module")
mv export/* $out

stopNest
