#! /bin/sh -e

initExpr=$1

make_dir() {
    mode=$1
    name=$2
    echo creating $name...
    if ! test -d $root/$name; then mkdir $root/$name; fi
    chmod $mode $root/$name
}

root=/tmp/mnt

echo mounting...
mount -t ext2 /dev/discs/disc0/disc $root

make_dir 00755 /dev
make_dir 00755 /proc
make_dir 01777 /tmp
make_dir 00755 /nix
make_dir 00755 /nix/store
make_dir 00755 /nix/var
make_dir 00755 /nix/var/nix
make_dir 00755 /nix/var/nix/db
make_dir 00755 /nix/var/log
make_dir 00755 /nix/var/log/nix

export NIX_ROOT=$root

echo initialising Nix DB...
/nix/bin/nix-store --init

echo verifying Nix DB...
/nix/bin/nix-store --verify

echo registering valid paths...
(while read storepath; do
    echo PATH $storepath
    if ! /nix/bin/nix-store --isvalid $storepath 2> /dev/null; then
        (unset NIX_ROOT; /nix/bin/nix-store --dump $storepath) | /nix/bin/nix-store --restore $storepath
        /nix/bin/nix-store --validpath $storepath
    fi
done) < /tmp/storepaths

echo registering successors...
(while read line; do
    echo SUCC $line
    /nix/bin/nix-store --successor $line
done) < /tmp/successors

echo setting init symlink...
initPath=$(/nix/bin/nix-store -qn $initExpr)
rm -f $root/init
ln -s $initPath/bin/init $root/init

echo unmounting...
umount $root

echo syncing...
sync

echo halting...
/sbin/halt -d -f
