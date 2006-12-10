source $stdenv/setup

set -o pipefail

objects=($objects)
symlinks=($symlinks)
suffices=($suffices)

mkdir root

# Needed for splash_helper, which gets run before init.
mkdir root/dev
mkdir root/sys
mkdir root/proc


for ((n = 0; n < ${#objects[*]}; n++)); do
    object=${objects[$n]}
    symlink=${symlinks[$n]}
    suffix=${suffices[$n]}
    if test "$suffix" = none; then suffix=; fi

    # Get the paths in the closure of `object'.
    closure=closure-$(basename $symlink)
    if ! test -e $closure; then
        echo 'Your Nix installation is too old! Upgrade to nix-0.11pre7038 or newer.'
        exit 1
    fi
    storePaths=$($SHELL $pathsFromGraph $closure)

    # Paths in cpio archives *must* be relative, otherwise the kernel
    # won't unpack 'em.
    (cd root && cp -prd --parents $storePaths .)

    mkdir -p $(dirname root/$symlink)
    ln -s $object$suffix root/$symlink
done


# Put the closure in a gzipped cpio archive.
ensureDir $out
(cd root && find * -print0 | cpio -ov -H newc --null | gzip -9 > $out/initrd)
