source $stdenv/setup

sources_=($sources)
targets_=($targets)

objects=($objects)
symlinks=($symlinks)


# Remove the initial slash from a path, since genisofs likes it that way.
stripSlash() {
    res="$1"
    if test "${res:0:1}" = /; then res=${res:1}; fi
}

stripSlash "$bootImage"; bootImage="$res"


if test -n "$bootable"; then

    # The -boot-info-table option modifies the $bootImage file, so
    # find it in `contents' and make a copy of it (since the original
    # is read-only in the Nix store...).
    for ((i = 0; i < ${#targets_[@]}; i++)); do
        stripSlash "${targets_[$i]}"
        if test "$res" = "$bootImage"; then
            echo "copying the boot image ${sources_[$i]}"
            cp "${sources_[$i]}" boot.img
            chmod u+w boot.img
            sources_[$i]=boot.img
        fi
    done

    bootFlags="-b $bootImage -c .boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table"
fi


touch pathlist


# Add the individual files.
for ((i = 0; i < ${#targets_[@]}; i++)); do
    stripSlash "${targets_[$i]}"
    echo "$res=${sources_[$i]}" >> pathlist
done


# Add the closures of the top-level store objects.
storePaths=$(perl $pathsFromGraph closure-*)
for i in $storePaths; do
    echo "${i:1}=$i" >> pathlist
done


# Also include a manifest of the closures in a format suitable for
# nix-store --load-db.
if [ -n "$object" ]; then
    printRegistration=1 perl $pathsFromGraph closure-* > nix-path-registration
    echo "nix-path-registration=nix-path-registration" >> pathlist
fi


# Add symlinks to the top-level store objects.
for ((n = 0; n < ${#objects[*]}; n++)); do
    object=${objects[$n]}
    symlink=${symlinks[$n]}
    if test "$symlink" != "none"; then
        mkdir -p $(dirname ./$symlink)
        ln -s $object ./$symlink
        echo "$symlink=./$symlink" >> pathlist
    fi
done

# !!! what does this do?
cat pathlist | sed -e 's/=\(.*\)=\(.*\)=/\\=\1=\2\\=/' | tee pathlist.safer


ensureDir $out/iso
genCommand="genisoimage -iso-level 4 -r -J $bootFlags -hide-rr-moved -graft-points -path-list pathlist.safer ${volumeID:+-V $volumeID}"
if test -z "$compressImage"; then
    $genCommand -o $out/iso/$isoName
else
    $genCommand | bzip2 > $out/iso/$isoName.bz2
fi


ensureDir $out/nix-support
echo $system > $out/nix-support/system
