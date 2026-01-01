<<<<<<< HEAD
runHook preFetch

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
# Repository list may contain ?. No glob expansion for that.
set -o noglob

success=
for repository in $repositories; do
    echo "Trying to clone $repository $tagtext into $out …"
    if darcs clone --lazy $tagflags "$repository" "$out"; then
        # remove metadata, because it can change
        rm -rf "$out/_darcs"
        success=1
        break
    fi
done

set +o noglob

if [ -z "$success" ]; then
    echo "Error: couldn’t clone repository from any mirror" 1>&2
    exit 1
fi

runHook postFetch
=======
echo "Cloning $url $partial ${tagtext} into $out"

darcs clone --lazy $tagflags "$url" "$out"
# remove metadata, because it can change
rm -rf "$out/_darcs"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
