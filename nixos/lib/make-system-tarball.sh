source $stdenv/setup
set -x

sources_=($sources)
targets_=($targets)

echo $objects
objects=($objects)
symlinks=($symlinks)


# Remove the initial slash from a path, since genisofs likes it that way.
stripSlash() {
    res="$1"
    if test "${res:0:1}" = /; then res=${res:1}; fi
}

touch pathlist

# Add the individual files.
for ((i = 0; i < ${#targets_[@]}; i++)); do
    stripSlash "${targets_[$i]}"
    mkdir -p "$(dirname "$res")"
    cp -a "${sources_[$i]}" "$res"
done


# Add the closures of the top-level store objects.
mkdir -p nix/store
storePaths=$(perl $pathsFromGraph closure-*)
for i in $storePaths; do
    cp -a "$i" "${i:1}"
done


# TODO tar ruxo
# Also include a manifest of the closures in a format suitable for
# nix-store --load-db.
printRegistration=1 perl $pathsFromGraph closure-* > nix-path-registration

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

tar --sort=name --mtime='@1' --owner=0 --group=0 --numeric-owner -cvJf $out/tarball/$fileName.tar.xz * $extraArgs

mkdir -p $out/nix-support
echo $system > $out/nix-support/system
echo "file system-tarball $out/tarball/$fileName.tar.xz" > $out/nix-support/hydra-build-products
