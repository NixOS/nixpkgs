source $stdenv/setup

sources_=($sources)
targets_=($targets)

objects=($objects)
symlinks=($symlinks)


if test -n "$bootable"; then
    bootFlags="-b $bootImage -c boot.cat -no-emul-boot -boot-load-size 4"
fi


graftList=
for ((i = 0; i < ${#targets_[@]}; i++)); do
    graftList="$graftList ${targets_[$i]}=$(readlink -f ${sources_[$i]})"
done


for ((n = 0; n < ${#objects[*]}; n++)); do
    object=${objects[$n]}
    symlink=${symlinks[$n]}

    # Get the paths in the closure of `object'.
    closure=closure-$(basename $symlink)
    if ! test -e $closure; then
        echo 'Your Nix installation is too old! Upgrade to nix-0.11pre7038 or newer.'
        exit 1
    fi
    storePaths=$($SHELL $pathsFromGraph $closure)

    for i in $storePaths; do
        graftList="$graftList ${i:1}=$i"
    done

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
