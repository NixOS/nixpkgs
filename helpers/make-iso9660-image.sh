source $stdenv/setup

if test -n "$bootable"; then
    bootFlags="-b $bootImage -c boot.cat -no-emul-boot -boot-load-size 4"
fi

graftList=
sources_=($sources)
targets_=($targets)
for ((i = 0; i < ${#targets_[@]}; i++)); do
    graftList="$graftList ${targets_[$i]}=$(readlink -f ${sources_[$i]})"
done

storePaths=$($SHELL $pathsFromGraph ./init-closure)

for i in $storePaths; do
    graftList="$graftList ${i:1}=$i"
done

if test -n "$init"; then
    ln -s $init init
    graftList="$graftList init=init"
fi

# !!! -f is a quick hack.
ensureDir $out/iso
mkisofs -r -J -o $out/iso/$isoName $bootFlags \
    -graft-points $graftList

ensureDir $out/nix-support
echo $system > $out/nix-support/system
