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
    for ((i = 0; i < ${#targets[@]}; i++)); do
        stripSlash "${targets[$i]}"
        if test "$res" = "$bootImage"; then
            echo "copying the boot image ${sources[$i]}"
            cp "${sources[$i]}" boot.img
            chmod u+w boot.img
            sources[$i]=boot.img
        fi
    done

    isoBootFlags="-eltorito-boot ${bootImage}
                  -eltorito-catalog .boot.cat
                  -no-emul-boot -boot-load-size 4 -boot-info-table
                  --sort-weight 1 /isolinux" # Make sure isolinux is near the beginning of the ISO
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
for ((i = 0; i < ${#targets[@]}; i++)); do
    stripSlash "${targets[$i]}"
    addPath "$res" "${sources[$i]}"
done


# Add the closures of the top-level store objects.
for i in $(< $closureInfo/store-paths); do
    addPath "${i:1}" "$i"
done

# If needed, build a squashfs and add that
if [[ -n "$squashfsCommand" ]]; then
    (out="nix-store.squashfs" eval "$squashfsCommand")
    addPath "nix-store.squashfs" "nix-store.squashfs"
fi

# Also include a manifest of the closures in a format suitable for
# nix-store --load-db.
if [[ ${#objects[*]} != 0 ]]; then
    cp $closureInfo/registration nix-path-registration
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

# daed2280-b91e-42c0-aed6-82c825ca41f3 is an arbitrary namespace, to prevent
# independent applications from generating the same UUID for the same value.
# (the chance of that being problematic seem pretty slim here, but that's how
# version-5 UUID's work)
xorriso="xorriso
 -boot_image any gpt_disk_guid=$(uuid -v 5 daed2280-b91e-42c0-aed6-82c825ca41f3 $out | tr -d -)
 -volume_date all_file_dates =$SOURCE_DATE_EPOCH
 -as mkisofs
 -iso-level 3
 -volid ${volumeID}
 -appid nixos
 -publisher nixos
 -graft-points
 -full-iso9660-filenames
 -joliet
 ${isoBootFlags}
 ${usbBootFlags}
 ${efiBootFlags}
 -r
 -path-list pathlist
 --sort-weight 0 /
"

$xorriso -output $out/iso/$isoName

if test -n "$compressImage"; then
    echo "Compressing image..."
    zstd -T$NIX_BUILD_CORES --rm $out/iso/$isoName
fi

mkdir -p $out/nix-support
echo $system > $out/nix-support/system

if test -n "$compressImage"; then
    echo "file iso $out/iso/$isoName.zst" >> $out/nix-support/hydra-build-products
else
    echo "file iso $out/iso/$isoName" >> $out/nix-support/hydra-build-products
fi
