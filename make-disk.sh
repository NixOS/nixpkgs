#! /bin/sh -e

image=/tmp/disk.img
size=$(expr 256 \* 1024 \* 1024)
storePaths=/tmp/storepaths
successors=/tmp/successors

if ! test -f $image; then 

    echo creating empty disk of $size bytes in $image...
    # Note: this is a sparse file.
    dd if=/dev/zero of=$image bs=1 seek=$(expr $size - 1) count=1

    echo creating disk image in $image...
    /sbin/mke2fs -F $image

fi

# What to copy?

NIX_CMD_PATH=/nix/bin

storeExpr=$(echo '(import ./pkgs.nix).everything' | $NIX_CMD_PATH/nix-instantiate -)
$NIX_CMD_PATH/nix-store -rB $storeExpr
$NIX_CMD_PATH/nix-store -qn --requisites $storeExpr > $storePaths

(while read storepath; do
  $NIX_CMD_PATH/nix-store -q --predecessors $storepath | (while read predecessor; do
    echo $predecessor $storepath
  done) 
done) < $storePaths > $successors

# Location of sysvinit?
sysvinitPath=$($NIX_CMD_PATH/nix-store -qn $(echo '(import ./pkgs.nix).sysvinit' | $NIX_CMD_PATH/nix-instantiate -))

# Location of Nix boot scripts?
bootPath=$($NIX_CMD_PATH/nix-store -qn $(echo '(import ./pkgs.nix).boot' | $NIX_CMD_PATH/nix-instantiate -))

# Fill the disk with the minimal Nix store.
if ! test -d /tmp/mnt; then mkdir /tmp/mnt; fi
linux ubd0=$image root=/dev/root rootflags=/ rootfstype=hostfs \
  init="$(pwd)/fill-disk.sh $sysvinitPath $bootPath"
