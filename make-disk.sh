#! /bin/sh -e

set -x

if test -z "$TMPDIR"; then export TMPDIR=/tmp; fi

# deps is an array
declare -a deps

build="nix-build --no-out-link"

coreutils=$($build ./pkgs.nix -A coreutils)

# determine where we can find the Nix binaries
NIX=$($coreutils/bin/dirname $(which nix-store))

# make sure we use many of our own tools, because it is more pure
mktemp=$($build ./pkgs.nix -A mktemp)

gnused=$($build ./pkgs.nix -A gnused)
gnutar=$($build ./pkgs.nix -A gnutar151)
cdrtools=$($build ./pkgs.nix -A cdrtools)
gzip=$($build ./pkgs.nix -A gzip)
cpio=$($build ./pkgs.nix -A cpio)

archivesDir=$($mktemp/bin/mktemp -d)
archivesDir2=$($mktemp/bin/mktemp -d)
manifest=${archivesDir}/MANIFEST
nixpkgs=./pkgs
fill_disk=$archivesDir/scripts/fill-disk.sh
ramdisk_login=$archivesDir/scripts/ramdisk-login.sh
login_script=$archivesDir/scripts/login.sh
storePaths=$archivesDir/mystorepaths
narStorePaths=$archivesDir/narstorepaths
validatePaths=$archivesDir/validatepaths
bootiso=$TMPDIR/nixos.iso
initrd=$TMPDIR/initram.img
initdir=${archivesDir}/initdir
initscript=$archivesDir/scripts/init.sh

nix=$($build ./pkgs.nix -A nix)
busybox=$($build ./pkgs.nix -A busybox)
nano=$($build ./pkgs.nix -A nano)
nanoDiet=$($build ./pkgs.nix -A nanoDiet)
ncurses=$($build ./pkgs.nix -A ncursesDiet)

nixDeps=$($NIX/nix-store -qR $nix)

storeExpr=$($build ./pkgs.nix -A boot)

kernelscripts=$($build ./pkgs.nix -A kernelscripts)

mkinitrd=$($build ./pkgs.nix -A mkinitrd)

### make NAR files for everything we want to install and some more. Make sure
### the right URL is in there, so specify /cdrom and not cdrom
$NIX/nix-push --copy $archivesDir $manifest --target file:///cdrom $storeExpr $($build ./pkgs.nix -A kernel) $kernelscripts $mkinitrd
#$NIX/nix-push --copy $archivesDir2 $manifest --target http://losser.labs.cs.uu.nl/~armijn/.nix $storeExpr $($build ./pkgs.nix -A kernel) $kernelscripts

# Location of sysvinit?
sysvinitPath=$($build ./pkgs.nix -A sysvinit)

# Location of Nix boot scripts?
bootPath=$($build ./pkgs.nix -A boot)

syslinux=$($build ./pkgs.nix -A syslinux)

kernel=$($build ./pkgs.nix -A kernel)
kernelscripts=$($build ./pkgs.nix -A kernelscripts)

utillinux=$($build ./pkgs.nix -A utillinux)

gnugrep=$($build ./pkgs.nix -A gnugrep)

grub=$($build ./pkgs.nix -A grubWrapper)

findutils=$($build ./pkgs.nix -A findutilsWrapper)

modutils=$($build ./pkgs.nix -A module_init_toolsStatic)

dhcp=$($build ./pkgs.nix -A dhcpWrapper)

#combideps=$($NIX/nix-store -qR $nix $utillinux $gnugrep $grub $gzip $findutils)
combideps=$($NIX/nix-store -qR $nix $busybox $grub $findutils $modutils $dhcp $nano)

for i in $storeExpr $mkinitrd
do
  echo $i >> $narStorePaths
done
#for i in $nixDeps
for i in $combideps
do
  echo $i >> $storePaths
  echo '' >> $storePaths
  deps=$($NIX/nix-store -q --references $i)
  pkgs=$(echo $deps | $coreutils/bin/wc -w)
  echo $pkgs >> $storePaths
  for j in $deps
  do
    echo $j >> $storePaths
  done
  echo copying from store: $i
  $gnutar/bin/tar -cf - $i | $gnutar/bin/tar --directory=$archivesDir -xf -
done

tar zcf ${archivesDir}/nixstore.tgz $combideps

utilLinux=$($build ./pkgs.nix -A utillinuxStatic)
coreUtilsDiet=$($NIX/nix-store -qR $($build ./pkgs.nix -A coreutilsDiet))

## temporarily normal e2fsprogs until I can get it to build with dietlibc
e2fsProgs=$($NIX/nix-store -qR $($build ./pkgs.nix -A e2fsprogsDiet))
#e2fsProgs=$($NIX/nix-store -qR $($build ./pkgs.nix -A e2fsprogs))
modUtils=$($NIX/nix-store -qR $($build ./pkgs.nix -A module_init_toolsStatic))
Grub=$($NIX/nix-store -qR $($build ./pkgs.nix -A grubWrapper))
Kernel=$($NIX/nix-store -qR $($build ./pkgs.nix -A kernel))
SysVinit=$($NIX/nix-store -qR $($build ./pkgs.nix -A sysvinit))
BootPath=$($NIX/nix-store -qR $($build ./pkgs.nix -A boot))

bashGlibc=$($build ./pkgs.nix -A bash)
bash=$($build ./pkgs.nix -A diet.bash)
coreutilsdiet=$($build ./pkgs.nix -A diet.coreutils)
utillinux=$($build ./pkgs.nix -A utillinux)
e2fsprogs=$($build ./pkgs.nix -A e2fsprogsDiet)
modutils=$($build ./pkgs.nix -A module_init_toolsStatic)
grub=$($build ./pkgs.nix -A grubWrapper)
mingettyWrapper=$($build ./pkgs.nix -A mingettyWrapper)
dhcp=$($build ./pkgs.nix -A dhcpWrapper)
gnugrep=$($build ./pkgs.nix -A gnugrep)
which=$($build ./pkgs.nix -A which)
eject=$($build ./pkgs.nix -A eject)
sysklogd=$($build ./pkgs.nix -A sysklogd)
#kudzu=$($build ./pkgs.nix -A kudzu)

echo creating directories for bootimage

$coreutils/bin/mkdir ${initdir}
$coreutils/bin/mkdir ${initdir}/bin
$coreutils/bin/mkdir ${initdir}/cdrom
$coreutils/bin/mkdir ${initdir}/dev
$coreutils/bin/mkdir ${initdir}/etc
$coreutils/bin/mkdir ${initdir}/etc/sysconfig
$coreutils/bin/mkdir ${initdir}/installimage
$coreutils/bin/mkdir ${initdir}/lib
$coreutils/bin/mkdir ${initdir}/modules
$coreutils/bin/mkdir ${initdir}/proc
$coreutils/bin/mkdir ${initdir}/sbin
$coreutils/bin/mkdir ${initdir}/sys
$coreutils/bin/mkdir ${initdir}/tmp
$coreutils/bin/mkdir -p ${initdir}/usr/bin
$coreutils/bin/mkdir -p ${initdir}/usr/sbin
$coreutils/bin/mkdir ${initdir}/var
$coreutils/bin/mkdir ${initdir}/var/run
$coreutils/bin/mkdir -p ${initdir}/var/state/dhcp

echo copying nixpkgs

#svn export ${nixpkgs} ${archivesDir}/pkgs
tar -zcf  ${archivesDir}/nixpkgs.tgz ${nixpkgs}

#echo copying packages from store

echo copying scripts

$coreutils/bin/mkdir ${archivesDir}/scripts
$coreutils/bin/cp -fa * ${archivesDir}/scripts
$gnused/bin/sed -e "s^@bash\@^$bash^g" \
    -e "s^@coreutils\@^$coreutilsdiet^g" \
    -e "s^@busybox\@^$busybox^g" \
    < $initscript > $initscript.tmp
$coreutils/bin/mv $initscript.tmp $initscript
$gnused/bin/sed -e "s^@sysvinitPath\@^$sysvinitPath^g" \
    -e "s^@bootPath\@^$bootPath^g" \
    -e "s^@nix\@^$nix^g" \
    -e "s^@bash\@^$bash^g" \
    -e "s^@bashGlibc\@^$bashGlibc^g" \
    -e "s^@findutils\@^$findutils^g" \
    -e "s^@busybox\@^$busybox^g" \
    -e "s^@coreutilsdiet\@^$coreutilsdiet^g" \
    -e "s^@coreutils\@^$coreutils^g" \
    -e "s^@utilLinux\@^$utilLinux^g" \
    -e "s^@utillinux\@^$utillinux^g" \
    -e "s^@e2fsprogs\@^$e2fsprogs^g" \
    -e "s^@modutils\@^$modutils^g" \
    -e "s^@grub\@^$grub^g" \
    -e "s^@kernel\@^$kernel^g" \
    -e "s^@kernelscripts\@^$kernelscripts^g" \
    -e "s^@gnugrep\@^$gnugrep^g" \
    -e "s^@which\@^$which^g" \
    -e "s^@dhcp\@^$dhcp^g" \
    -e "s^@sysklogd\@^$sysklogd^g" \
    -e "s^@gnutar\@^$gnutar^g" \
    -e "s^@gzip\@^$gzip^g" \
    -e "s^@mingetty\@^$mingettyWrapper^g" \
    < $fill_disk > $fill_disk.tmp
$coreutils/bin/mv $fill_disk.tmp $fill_disk

$gnused/bin/sed -e "s^@sysvinitPath\@^$sysvinitPath^g" \
    -e "s^@bootPath\@^$bootPath^g" \
    -e "s^@NIX\@^$nix^g" \
    -e "s^@bash\@^$bash^g" \
    -e "s^@findutils\@^$findutils^g" \
    -e "s^@coreutilsdiet\@^$coreutilsdiet^g" \
    -e "s^@coreutils\@^$coreutils^g" \
    -e "s^@utillinux\@^$utilLinux^g" \
    -e "s^@e2fsprogs\@^$e2fsprogs^g" \
    -e "s^@modutils\@^$modutils^g" \
    -e "s^@grub\@^$grub^g" \
    -e "s^@kernel\@^$kernel^g" \
    -e "s^@kernelscripts\@^$kernelscripts^g" \
    -e "s^@gnugrep\@^$gnugrep^g" \
    -e "s^@which\@^$which^g" \
    -e "s^@gnutar\@^$gnutar^g" \
    -e "s^@mingetty\@^$mingettyWrapper^g" \
    -e "s^@busybox\@^$busybox^g" \
    < $ramdisk_login > $ramdisk_login.tmp
$coreutils/bin/mv $ramdisk_login.tmp $ramdisk_login

$gnused/bin/sed -e "s^@sysvinitPath\@^$sysvinitPath^g" \
    -e "s^@bootPath\@^$bootPath^g" \
    -e "s^@NIX\@^$nix^g" \
    -e "s^@bash\@^$bash^g" \
    -e "s^@findutils\@^$findutils^g" \
    -e "s^@coreutilsdiet\@^$coreutilsdiet^g" \
    -e "s^@coreutils\@^$coreutils^g" \
    -e "s^@utillinux\@^$utilLinux^g" \
    -e "s^@e2fsprogs\@^$e2fsprogs^g" \
    -e "s^@modutils\@^$modutils^g" \
    -e "s^@grub\@^$grub^g" \
    -e "s^@kernel\@^$kernel^g" \
    -e "s^@kernelscripts\@^$kernelscripts^g" \
    -e "s^@gnugrep\@^$gnugrep^g" \
    -e "s^@which\@^$which^g" \
    -e "s^@gnutar\@^$gnutar^g" \
    -e "s^@mingetty\@^$mingettyWrapper^g" \
    -e "s^@busybox\@^$busybox^g" \
    -e "s^@nano\@^$nanoDiet^g" \
    < $login_script > $login_script.tmp
$coreutils/bin/mv $login_script.tmp $login_script

echo copying bootimage

$coreutils/bin/mkdir ${archivesDir}/isolinux
$coreutils/bin/cp ${syslinux}/lib/syslinux/isolinux.bin ${archivesDir}/isolinux
$coreutils/bin/cp isolinux.cfg ${archivesDir}/isolinux
$coreutils/bin/chmod u+w ${archivesDir}/isolinux/*

echo copying kernel

# By following the symlink we don't have to know the version number
# of the kernel here.
$coreutils/bin/cp -L $kernel/vmlinuz ${archivesDir}/isolinux

strippedName=$(basename $kernel);
if echo "$strippedName" | grep -q '^[a-z0-9]\{32\}-'; then
        strippedName=$(echo "$strippedName" | cut -c34- | cut -c 7-)
fi

kernelhash=$(basename $root/$kernel);
if echo "$kernelhash" | grep -q '^[a-z0-9]\{32\}-'; then
        kernelhash=$(echo "$kernelhash" | cut -c -32)
fi

version=$strippedName-$kernelhash

echo version: $version

#echo linking kernel modules
#$coreutils/bin/ln -s $kernel/lib $archivesDir/lib

echo copying network drivers
#$coreutils/bin/cp -fau --parents --no-preserve=mode $kernel/lib/modules/*/modules.* $archivesDir
#$coreutils/bin/cp -fau --parents --no-preserve=mode $kernel/lib/modules/*/kernel/drivers/net/* $archivesDir

$gnutar/bin/tar -cf - $kernel/lib/modules/*/modules.* | $gnutar/bin/tar --directory=$archivesDir --strip-components 3 -xf -
$gnutar/bin/tar -cf - $kernel/lib/modules/*/kernel/drivers/net/* | $gnutar/bin/tar --directory=$archivesDir --strip-components 3 -xf -

echo creating ramdisk

umask 0022

$coreutils/bin/rm -f ${initrd}
#cp ${archivesDir}/scripts/fill-disk.sh ${initdir}/init
$coreutils/bin/cp ${archivesDir}/scripts/fill-disk.sh ${initdir}/
$coreutils/bin/cp ${archivesDir}/scripts/ramdisk-login.sh ${initdir}/
$coreutils/bin/cp ${archivesDir}/scripts/login.sh ${initdir}/
$coreutils/bin/cp ${archivesDir}/scripts/init.sh ${initdir}/init
#ln -s ${bash}/bin/bash ${initdir}/bin/sh
$coreutils/bin/cp ${bash}/bin/bash ${initdir}/bin/sh
$coreutils/bin/chmod u+x ${initdir}/init
$coreutils/bin/chmod u+x ${initdir}/fill-disk.sh
$coreutils/bin/chmod u+x ${initdir}/ramdisk-login.sh
$coreutils/bin/chmod u+x ${initdir}/login.sh
#cp -fau --parents ${utilLinux} ${initdir}
#cp -fau --parents ${coreUtilsDiet} ${initdir}
#cp -fau --parents ${modUtils} ${initdir}
$coreutils/bin/cp -fau --parents ${bash}/bin ${initdir}
#$coreutils/bin/cp -fau --parents ${utilLinux}/bin ${initdir}
#$coreutils/bin/chmod -R u+w ${initdir}
#$coreutils/bin/cp -fau --parents ${utilLinux}/sbin ${initdir}
$coreutils/bin/cp -fau --parents ${e2fsProgs} ${initdir}
#$coreutils/bin/cp -fau --parents ${coreutilsdiet}/bin ${initdir}
$coreutils/bin/cp -fau --parents ${modutils}/bin ${initdir}
$coreutils/bin/chmod -R u+w ${initdir}
$coreutils/bin/cp -fau --parents ${modutils}/sbin ${initdir}
$coreutils/bin/cp -fau --parents ${busybox} ${initdir}
$coreutils/bin/cp -fau --parents ${nanoDiet} ${initdir}
$coreutils/bin/cp -fau --parents ${ncurses} ${initdir}

$coreutils/bin/touch ${archivesDir}/NIXOS

(cd ${initdir}; find . |$cpio/bin/cpio -H newc -o) | $gzip/bin/gzip -9 > ${initrd}

$coreutils/bin/chmod -f -R +w ${initdir}/*
$coreutils/bin/rm -rf ${initdir}

$coreutils/bin/cp ${initrd} ${archivesDir}/isolinux
$coreutils/bin/rm -f ${initrd}

echo creating ISO image

$cdrtools/bin/mkisofs -rJ -o ${bootiso} -b isolinux/isolinux.bin \
                -c isolinux/boot.cat  -no-emul-boot -boot-load-size 4 \
                -boot-info-table ${archivesDir}

# cleanup, be diskspace friendly

echo cleaning up

$coreutils/bin/chmod -f -R +w ${archivesDir}/*
#rm -rf ${archivesDir}/*
