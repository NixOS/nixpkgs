source $stdenv/setup

sources_=($sources)
targets_=($targets)

objects=($objects)
symlinks=($symlinks)


if test -n "$bootable"; then
    bootFlags="-b $bootImage -c boot.cat -no-emul-boot -boot-load-size 4"
fi


# Add the individual files.
graftList=
for ((i = 0; i < ${#targets_[@]}; i++)); do
    graftList="$graftList ${targets_[$i]}=$(readlink -f ${sources_[$i]})"
done


# Add the closures of the top-level store objects.
storePaths=$(perl $pathsFromGraph closure-*)
for i in $storePaths; do
    graftList="$graftList ${i:1}=$i"
done


# Also put a nix-pull manifest of the closures on the CD.
printManifest=1 perl $pathsFromGraph closure-* > MANIFEST
graftList="$graftList MANIFEST=MANIFEST"


# Add symlinks to the top-level store objects.
for ((n = 0; n < ${#objects[*]}; n++)); do
    object=${objects[$n]}
    symlink=${symlinks[$n]}
    if test "$symlink" != "none"; then
        mkdir -p $(dirname ./$symlink)
        ln -s $object ./$symlink
        graftList="$graftList $symlink=./$symlink"
    fi
done


# !!! -f is a quick hack.
ensureDir $out/iso
mkisofs -r -J -o $out/iso/$isoName $bootFlags \
    -graft-points $graftList

ensureDir $out/nix-support
echo $system > $out/nix-support/system
