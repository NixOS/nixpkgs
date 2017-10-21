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

# Escape potential equal signs (=) with backslash (\=)
escapeEquals() {
    echo "$1" | sed -e 's/\\/\\\\/g' -e 's/=/\\=/g'
}

# Queues an file/directory to be placed on the ISO.
# An entry consists of a local source path (2) and
# a destination path on the ISO (1).
addPath() {
    target="$1"
    source="$2"
    echo "$(escapeEquals "$target")=$(escapeEquals "$source")" >> pathlist
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

    isoBootFlags="-eltorito-boot ${bootImage}
                  -eltorito-catalog .boot.cat
                  -no-emul-boot -boot-load-size 4 -boot-info-table"
fi

if test -n "$usbBootable"; then
    usbBootFlags="-isohybrid-mbr ${isohybridMbrImage}"
fi

if test -n "$efiBootable"; then
    efiBootFlags="-eltorito-alt-boot
                  -e $efiBootImage
                  -no-emul-boot
                  -isohybrid-gpt-basdat"
fi

touch pathlist


# Add the individual files.
for ((i = 0; i < ${#targets_[@]}; i++)); do
    stripSlash "${targets_[$i]}"
    addPath "$res" "${sources_[$i]}"
done


# Add the closures of the top-level store objects.
storePaths=$(perl $pathsFromGraph closure-*)
for i in $storePaths; do
    addPath "${i:1}" "$i"
done


# Also include a manifest of the closures in a format suitable for
# nix-store --load-db.
if [ -n "$object" ]; then
    printRegistration=1 perl $pathsFromGraph closure-* > nix-path-registration
    addPath "nix-path-registration" "nix-path-registration"
fi


# Add symlinks to the top-level store objects.
for ((n = 0; n < ${#objects[*]}; n++)); do
    object=${objects[$n]}
    symlink=${symlinks[$n]}
    if test "$symlink" != "none"; then
        mkdir -p $(dirname ./$symlink)
        ln -s $object ./$symlink
        addPath "$symlink" "./$symlink"
    fi
done

mkdir -p $out/iso

xorriso="xorriso
 -as mkisofs
 -iso-level 3
 -volid ${volumeID}
 -appid nixos
 -publisher nixos
 -graft-points
 -full-iso9660-filenames
 ${isoBootFlags}
 ${usbBootFlags}
 ${efiBootFlags}
 -r
 -path-list pathlist
 --sort-weight 0 /
 --sort-weight 1 /isolinux" # Make sure isolinux is near the beginning of the ISO

$xorriso -output $out/iso/$isoName

if test -n "$usbBootable"; then
    echo "Making image hybrid..."
    if test -n "$efiBootable"; then
        isohybrid --uefi $out/iso/$isoName
    else
        isohybrid $out/iso/$isoName
    fi
fi

if test -n "$compressImage"; then
    echo "Compressing image..."
    bzip2 $out/iso/$isoName
fi

mkdir -p $out/nix-support
echo $system > $out/nix-support/system
echo "file iso $out/iso/$isoName" >> $out/nix-support/hydra-build-products
