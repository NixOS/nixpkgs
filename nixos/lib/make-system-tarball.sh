# Remove the initial slash from a path, since genisofs likes it that way.
stripSlash() {
    res="$1"
    if test "${res:0:1}" = /; then res=${res:1}; fi
}

# Add the individual files.
for ((i = 0; i < ${#targets[@]}; i++)); do
    stripSlash "${targets[$i]}"
    mkdir -p "$(dirname "$res")"
    cp -a "${sources[$i]}" "$res"
done


# Add the closures of the top-level store objects.
chmod +w .
mkdir -p nix/store
for i in $(< $closureInfo/store-paths); do
    cp -a "$i" "${i:1}"
done


# TODO tar ruxo
# Also include a manifest of the closures in a format suitable for
# nix-store --load-db.
cp $closureInfo/registration nix-path-registration

# Add symlinks to the top-level store objects.
for ((n = 0; n < ${#objects[*]}; n++)); do
    object=${objects[$n]}
    symlink=${symlinks[$n]}
    if test "$symlink" != "none"; then
        mkdir -p $(dirname ./$symlink)
        ln -s $object ./$symlink
    fi
done

$extraCommands

mkdir -p $out/tarball

rm env-vars

time tar --sort=name --mtime='@1' --owner=0 --group=0 --numeric-owner -c * $extraArgs | $compressCommand > $out/tarball/$fileName.tar${extension}

mkdir -p $out/nix-support
echo $system > $out/nix-support/system
echo "file system-tarball $out/tarball/$fileName.tar${extension}" > $out/nix-support/hydra-build-products
