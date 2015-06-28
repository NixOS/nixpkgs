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

    mkdir -p $(dirname root/$symlink)
    ln -s $object$suffix root/$symlink
done


# Get the paths in the closure of `object'.
storePaths=$(perl $pathsFromGraph closure-*)


# Paths in cpio archives *must* be relative, otherwise the kernel
# won't unpack 'em.
(cd root && cp -prd --parents $storePaths .)


# Put the closure in a gzipped cpio archive.
mkdir -p $out
for PREP in $prepend; do
  cat $PREP >> $out/initrd
done
(cd root && find * -print0 | cpio -o -H newc --null | perl $cpioClean | $compressor >> $out/initrd)

if [ -n "$makeUInitrd" ]; then
    mv $out/initrd $out/initrd.gz
    mkimage -A arm -O linux -T ramdisk -C gzip -d $out/initrd.gz $out/initrd
fi
