set -e
set -x

# Restore the original variables.
export NIX_BUILD_TOP=$1
. $NIX_BUILD_TOP/initial-env-vars

export PATH=$(< $NIX_BUILD_TOP/path)

export NIX_STORE=/nix/store # !!! assuming that Nix store = /nix/store

cd $NIX_BUILD_TOP

root=$NIX_BUILD_TOP/root

echo "remounting / writeable..."
mount -n -o remount,rw dummy /

exec > log 2>&1

echo "creating /dev..."
mount -n -t tmpfs none /dev
mknod /dev/ubd0 b 98 0

echo "mounting image on $root..."
mkdir root
mount -n -t ext2 /dev/ubd0 $root

echo "switching roots"
mkdir $root/hostfs

# Make the Nix store available in the UML file system as a symlink to /hostfs/$NIX_STORE.
mkdir -p $root/$(dirname $NIX_STORE)
ln -s /hostfs/$NIX_STORE $root/$NIX_STORE 

$utillinux/sbin/pivot_root $root $root/hostfs
cd /
# !!! we should also chroot here (according to the pivot_root manpage)

echo "mounting /proc..."
mount -n -t proc none /proc

#mount --bind /hostfs/tmp /tmp

cd /tmp
export TMPDIR=/tmp
export TMP_DIR=/tmp
#cd $NIX_BUILD_TOP

# Call the actual builder.
if sh -e $actualBuilder; then
    touch /hostfs/$NIX_BUILD_TOP/success
fi

echo "syncing..."
sync

echo "halting..."
$sysvinit/sbin/halt -d -f
