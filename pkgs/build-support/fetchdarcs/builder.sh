if [ -e .attrs.sh ]; then source .attrs.sh; fi
source $stdenv/setup

tagtext=""
tagflags=""
if test -n "$rev"; then
    tagtext="(tag $rev) "
    tagflags="--tag=$rev"
elif test -n "$context"; then
    tagtext="(context) "
    tagflags="--context=$context"
fi

echo "getting $url $partial ${tagtext} into $out"

darcs get --lazy $tagflags "$url" "$out"
# remove metadata, because it can change
rm -rf "$out/_darcs"
