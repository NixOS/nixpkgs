#! @bash@/bin/sh -e

export PATH=/bin:/sbin:@bash@/bin:@findutils@/bin:@e2fsprogs@/sbin:@grub@/sbin:@sysvinitPath@/sbin:@eject@/bin:@dhcp@/sbin:@modutils@/sbin:@busybox@/bin:@busybox@/sbin

kernel=@kernel@
xawtv=@xawtv@

narStorePaths=/cdrom/narstorepaths

sysvinitPath=@sysvinitPath@
bootPath=@bootPath@
modutils=@modutils@
mingetty=@mingetty@

echo formatting target device

if test -e disklayout; then
  source disklayout
else
  echo no disk layout configuration present...exiting
  exit 1
fi

# $targetdrive is also used by GRUB!
#targetdrive=/dev/hda
targetdrive=${TARGETDRIVE}
#device=${targetdrive}1
device=${INSTALLDEVICE}
mkfs.ext2 ${device}
#swapdevice=${targetdrive}2
swapdevice=${SWAP}
mkswap $swapdevice

echo enabling swap

swapon $swapdevice

#if ! test -n "$1"
#then
#    echo "need harddisk device for installing!"
#    exit
#else
#    device=$1
#fi

##
## Two convenience shell functions
##

make_dir() {
    mode=$1
    name=$2
    echo creating $name...
    if ! test -d $root/$name; then mkdir $root/$name; fi
    chmod $mode $root/$name
}

touch_file() {
    name=$1
    echo touching $name...
    if ! test -d $root/$name; then touch $root/$name; fi
}
root=/tmp/mnt

mkdir -p $root

echo mounting the target drive

mount -t ext2 $device $root

##
## Create a directory tree on the installation disk.
##

echo creating file system hierarchy on target drive

make_dir 00755 /bin
make_dir 00755 /boot
make_dir 00755 /cdrom
make_dir 00755 /dev
make_dir 00755 /dev/pts
make_dir 00755 /etc # global non-constant configuration
make_dir 00755 /etc/ssh
make_dir 00755 /etc/sysconfig
make_dir 00755 /home
make_dir 00755 /lib
make_dir 00755 /lib/modules
make_dir 00755 /mnt
make_dir 00755 /mnt/host
make_dir 00755 /nix
make_dir 00755 /nix/store
make_dir 00755 /nix/var
make_dir 00755 /nix/var/nix
make_dir 00755 /nix/var/nix/db
make_dir 00755 /nix/var/nix/gcroots
make_dir 00755 /nix/var/nix/manifests
make_dir 00755 /nix/var/nix/profiles
make_dir 00755 /nix/var/nix/temproots
make_dir 00755 /nix/var/log
make_dir 00755 /nix/var/log/nix
make_dir 00755 /proc
make_dir 00750 /root
make_dir 00755 /sbin
make_dir 00755 /sys
make_dir 01777 /tmp
make_dir 00755 /usr
make_dir 00755 /var
make_dir 00755 /var/empty
make_dir 00111 /var/empty/sshd
make_dir 00755 /var/lock
make_dir 00755 /var/lock/subsys
make_dir 00755 /var/log
make_dir 00755 /var/run
make_dir 00755 /var/run/usb
make_dir 00755 /var/spool
make_dir 00755 /var/state
make_dir 00755 /var/state/dhcp
make_dir 00755 /var/tmp

##
## Add a few devices to /dev on the install disk. This is by far complete.
##

echo making device nodes on target drive

mknod -m 0666 $root/dev/null c 1 3
mknod -m 0600 $root/dev/console c 5 1
mknod -m 0600 $root/dev/tty c 5 0
mknod -m 0600 $root/dev/tty0 c 4 0
mknod -m 0600 $root/dev/tty1 c 4 1
mknod -m 0600 $root/dev/tty2 c 4 2
mknod -m 0600 $root/dev/tty3 c 4 3
mknod -m 0444 $root/dev/urandom c 1 9

rm -f $root/etc/mtab
ln -s /proc/mounts $root/etc/mtab

# prevent df from barfing
ln -s /proc/mounts /etc/mtab

## Probe for CD device which contains our CD here and mount /nix and
## /nixpkgs from it inside the ramdisk. Anaconda uses kudzu for this.
## Find out how Knoppix and SUSE do this...

DEVICES="/dev/hd?"

for i in ${DEVICES}
do
echo "Looking for CDROM in: $i"
  if mount -t iso9660 $i /cdrom >/dev/null 2>&1
  then
    if test -f /cdrom/NIXOS
    then
      cddevice=$i
      echo "Accessing NixOS CDROM at $i"
    break
    fi
  fi
done

echo mounting /cdrom in the target

mount --bind /cdrom $root/cdrom
mount --bind /cdrom/lib /lib

echo switch to /nix from CD
## starting here it's OK to have full blown glibc

mount --bind /cdrom/nix /nix

#echo probing for hardware...

#kudzu

export NIX_DATA_DIR=$root/nix/share
export NIX_LOG_DIR=$root/nix/log/nix
export NIX_STATE_DIR=$root/nix/var/nix
export NIX_CONF_DIR=$root/nix/etc
NIX=@nix@/bin

echo bringing up networking...

#labmachine has 3c59x
#modprobe 3c59x
#vmware has pcnet32
modprobe pcnet32
dhclient eth0

cp /etc/resolv.conf $root/etc/resolv.conf

#nic=`kudzu -p | grep eth | sort | uniq | cut -d ' ' -f 2`

#echo "NIC: $nic"

echo initialising Nix DB...
$NIX/nix-store --init

echo verifying Nix DB...
$NIX/nix-store --verify

echo copying nixpkgs...
tar --directory=$root -zxf /cdrom/nixpkgs.tgz

make_dir 0755 /tmp/scripts
cp -fa /cdrom/scripts $root/tmp

echo adding packages

export NIX_ROOT=$root
unset NIX_DATA_DIR
unset NIX_LOG_DIR
unset NIX_STATE_DIR
unset NIX_CONF_DIR

cp /cdrom/mystorepaths $root/tmp

echo copying store

tar --directory=$root -zxf /cdrom/nixstore.tgz

echo registering valid paths...

$NIX/nix-store --register-validity < $root/tmp/mystorepaths

unset NIX_ROOT
export NIX_DATA_DIR=$root/nix/share
export NIX_LOG_DIR=$root/nix/log/nix
export NIX_STATE_DIR=$root/nix/var/nix
export NIX_CONF_DIR=$root/nix/etc

echo creating /bin/sh
ln -s @bashGlibc@/bin/sh $root/bin/sh

echo adding manifest
$NIX/nix-pull file:///cdrom/MANIFEST

export NIX_ROOT=$root
unset NIX_DATA_DIR
unset NIX_LOG_DIR
unset NIX_STATE_DIR
unset NIX_CONF_DIR

## Fix this. Probably nix-instantiate, then nix-store -r.
## Also make sure everything gets installed into an actual profile!

$NIX/nix-env -iKf /nixpkgs/trunk/pkgs/top-level/all-packages.nix -A nixUnstable
$NIX/nix-env -iKf /nixpkgs/trunk/pkgs/top-level/all-packages.nix -A coreutils
$NIX/nix-env -iKf /nixpkgs/trunk/pkgs/top-level/all-packages.nix -A gnugrep
#$NIX/nix-env -iKf /nixpkgs/trunk/pkgs/top-level/all-packages.nix -A kernel
$NIX/nix-env -iKf /nixpkgs/trunk/pkgs/top-level/all-packages.nix -A kernelscripts
$NIX/nix-env -iKf /nixpkgs/trunk/pkgs/top-level/all-packages.nix -A grub

cat $narStorePaths | xargs -n 1 -i% $NIX/nix-env -i %

echo setting init symlink...
rm -f $root/init
#ln -s $sysvinitPath/sbin/init $root/init
ln -s @sysvinitPath@/sbin/init $root/sbin/init
#ln -s @bash@/bin/bash $root/bin/bash

echo setting up inittab...
rm -f $root/etc/inittab
echo "id:2:initdefault:" >> $root/etc/inittab
echo "si::bootwait:$bootPath/bin/boot.sh" >> $root/etc/inittab
echo "ht:06:wait:$bootPath/bin/halt.sh" >> $root/etc/inittab
echo "1:2345:respawn:$bootPath/bin/login.sh /dev/tty1" >> $root/etc/inittab
echo "#2:2345:respawn:$mingetty/sbin/mingetty tty2" >> $root/etc/inittab
echo "#3:2345:respawn:$mingetty/sbin/mingetty tty3" >> $root/etc/inittab
#echo "2:2345:respawn:$bootPath/bin/login.sh /dev/ttys/1" >> $root/etc/inittab

echo setting up networking information...

make_dir 00755 /etc/networking
#cp /etc/resolv.conf $root/etc
rm -f $root/etc/hosts
echo "127.0.0.1 localhost" >> $root/etc/hosts

echo storing hardware information...

#kudzu -p > $root/etc/sysconfig/hwconf
#cp /etc/modprobe.conf $root/etc/

echo setting up initial account information...

echo "root:x:0:root" > $root/etc/group
echo "sshd:x:74:" >> $root/etc/group
echo "root:x:0:0:root:/root:/bin/sh" > $root/etc/passwd
echo "sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin" >> $root/etc/passwd
echo "root::12757:0:99999:7:::" >> $root/etc/shadow
echo "sshd:!!:12757:0:99999:7:::" >> $root/etc/shadow

echo default profile for root
echo "source @nix@/etc/profile.d/nix.sh" > $root/root/.profile

touch_file /etc/login.defs
touch_file /etc/services

##
## Do kernel stuff here.
##
strippedName=$(basename $root/@kernel@);
if echo "$strippedName" | grep -q '^[a-z0-9]\{32\}-'; then
        strippedName=$(echo "$strippedName" | cut -c34- | cut -c 7-)
fi

kernelhash=$(basename $root/@kernel@);
if echo "$kernelhash" | grep -q '^[a-z0-9]\{32\}-'; then
        kernelhash=$(echo "$kernelhash" | cut -c -32)
fi

version=$strippedName-$kernelhash

ln -s @kernelscripts@/lib/modules/$version $root/lib/modules/$version

##
## init
##

ln -s $device $root/dev/root
ln -s @sysvinitPath@/sbin/init /sbin/init

##
## Do funky stuff with grub here.
##

echo installing bootloader

grub-install --root-directory=${root} --no-floppy ${targetdrive}

# FIXME "root (hd0,0)"
cat > $root/boot/grub/menu.lst << GRUBEND
default=0
timeout=5
title NixOS
        kernel @kernel@/vmlinuz root=$device
GRUBEND

echo clearing substitutes

$NIX/nix-store --clear-substitutes

echo clearing network information

rm $root/etc/resolv.conf

echo copying install log

cp /tmp/install-log $root/root

# bizar. busybox umount doesn't like things with --bind it seems.
echo umounting filesystem

umount $root/cdrom
umount $root
#umount /nix
umount /cdrom
#echo ejecting $cddevice
#eject $cddevice

echo install done
echo it\'s safe to turn off your machine
echo exiting install process

#while true; do
   #sleep 60;
#done
