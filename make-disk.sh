#! /bin/sh -e

image=/tmp/disk.img
size=$(expr 256 \* 1024 \* 1024)
storepaths=/tmp/storepaths
successors=/tmp/successors

if ! test -f $image; then 

    echo creating empty disk of $size bytes in $image...
    # Note: this is a sparse file.
    dd if=/dev/zero of=$image bs=1 seek=$(expr $size - 1) count=1

    echo creating disk image in $image...
    /sbin/mke2fs -F $image

fi


# What to copy?
storeexpr=$(echo '(import ./pkgs.nix).init' | nix-instantiate -)
nix-store -rB $storeexpr
nix-store -qn --requisites $storeexpr > $storepaths

(while read storepath; do
  nix-store -q --predecessors $storepath | (while read predecessor; do
    echo $predecessor $storepath
  done) 
done) < $storepaths > $successors

# Fill the disk with the minimal Nix store.
if ! test -d /tmp/mnt; then mkdir /tmp/mnt; fi
linux ubd0=$image root=/dev/root rootflags=/ rootfstype=hostfs init="$(pwd)/fill-disk.sh $storeexpr"

