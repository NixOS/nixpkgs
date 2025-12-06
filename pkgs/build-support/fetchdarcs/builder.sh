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

# Repository list may contain ?. No glob expansion for that.
set -o noglob

for repository in $repositories; do
    echo "Trying to clone $repository $tagtext into $out …"
    if darcs clone --lazy $tagflags "$repository" "$out"; then
        # remove metadata, because it can change
        rm -rf "$out/_darcs"
        exit 0
    fi
done

set +o noglob

echo "Error: couldn’t clone repository from any mirror" 1>&2
exit 1
