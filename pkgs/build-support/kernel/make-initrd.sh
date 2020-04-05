set -o pipefail

mkdir root

# Needed for splash_helper, which gets run before init.
mkdir root/dev
mkdir root/sys
mkdir root/proc

objectCount=$(<.attrs.json jq '.contents | length')

for ((n = 0; n < $objectCount; n++)); do
    object=$(<.attrs.json jq -r ".contents[$n].object")
    symlink=$(<.attrs.json jq -r ".contents[$n].symlink")
    suffix=$(<.attrs.json jq -r '.contents['"$n"'] | if has("suffix") then .suffix else "" end')
    if test "$suffix" = none; then suffix=; fi

    mkdir -p $(dirname root/$symlink)
    ln -s $object$suffix root/$symlink
done

# Paths in cpio archives *must* be relative, otherwise the kernel
# won't unpack 'em.
(cd root && cp -prd --parents $(cat "$closure/store-paths") .)


# Put the closure in a gzipped cpio archive.
mkdir -p $out
for PREP in $prepend; do
  cat $PREP >> $out/initrd
done
(cd root && find * -print0 | xargs -0r touch -h -d '@1')
(cd root && find * -print0 | sort -z | cpio -o -H newc -R +0:+0 --reproducible --null | $compressor >> $out/initrd)

if [ -n "$makeUInitrd" ]; then
    mv $out/initrd $out/initrd.gz
    mkimage -A arm -O linux -T ramdisk -C gzip -d $out/initrd.gz $out/initrd
fi
