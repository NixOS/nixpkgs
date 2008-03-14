set -e
set -x

export NIX_BUILD_TOP=$1

export PATH=$(< $NIX_BUILD_TOP/path)
export sysvinit=$(< $NIX_BUILD_TOP/sysvinit)
export postInstall=$(< $NIX_BUILD_TOP/post-install)
export rpm=$(< $NIX_BUILD_TOP/rpm)

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

echo "making directories..."
mkdir --mode 0755 $root/dev
mkdir --mode 0755 $root/proc

echo "initialising RPM DB..."
rpm="$rpm/bin/rpm --root $root --dbpath /var/lib/rpm"
$rpm --initdb

echo "installing RPMs..."
$rpm --noscripts --notriggers --nodeps -ihv $(cat rpms)

if test -n "$postInstall"; then
    echo "running post-install script"
    . $postInstall
fi

# Get rid of the Berkeley DB environment so that older RPM versions
# (using older versions of BDB) will still work.
rm -f root/var/lib/rpm/__db.*

# We need to make devices because modern distributions (e.g., Fedora
# Core 3) use udev to create devices dynamically.  We run into *very*
# subtle bugs if /dev/null in particular doesn't exist ;-)
echo "making devices..."
test -e $root/dev/null || mknod -m 0666 $root/dev/null c 1 3
test -e $root/dev/zero || mknod -m 0666 $root/dev/zero c 1 5
test -e $root/dev/tty  || mknod -m 0600 $root/dev/tty  c 5 0

echo "unmounting..."
umount -n $root

touch $NIX_BUILD_TOP/success
    
echo "syncing..."
sync

echo "halting..."
$sysvinit/sbin/halt -d -f
