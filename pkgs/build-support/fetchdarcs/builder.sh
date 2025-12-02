set -u

tagtext=""
tagflags=""
# Darcs hashes are sha1 (120 bits, 40-character hex)
if [[ "$rev" =~ [a-fA-F0-9]{40} ]]; then
    tagtext="(hash $rev)"
    tagflags="--to-hash=$rev"
elif test -n "$rev"; then
    tagtext="(tag $rev)"
    tagflags="--tag=$rev"
elif test -n "$context"; then
    tagtext="(context)"
    tagflags="--context=$context"
fi

echo "Cloning $url ${tagtext} into $out"

darcs clone --lazy $tagflags "$url" "$out"
# remove metadata, because it can change
rm -rf "$out/_darcs"
