#! /bin/sh -e

# deps is an array
declare -a deps

# determine where we can find the Nix binaries
NIX=$(dirname $(which nix-store))

# make sure we use our own mktemp, because it is more pure
mktemp=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).mktemp' | $NIX/nix-instantiate -))
archivesDir=$($mktemp/bin/mktemp -d)

manifest=${archivesDir}/MANIFEST
nixpkgs=/nixpkgs/trunk/pkgs
fill_disk=$archivesDir/scripts/fill-disk.sh
ramdisk_login=$archivesDir/scripts/ramdisk-login.sh
storePaths=$archivesDir/mystorepaths
validatePaths=$archivesDir/validatepaths
bootiso=/tmp/nixos.iso
initrd=/tmp/initram.img
initdir=${archivesDir}/initdir
initscript=$archivesDir/scripts/init.sh


storeExpr=$($NIX/nix-store -qR $($NIX/nix-store -r $(echo '(import ./pkgs.nix).everything' | $NIX/nix-instantiate -)))
#$NIX/nix-push --copy $archivesDir $manifest $($NIX/nix-store -r $storeExpr) $($NIX/nix-store -r $(echo '(import ./pkgs.nix).kernel' | $NIX/nix-instantiate -))

# Location of sysvinit?
sysvinitPath=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).sysvinit' | $NIX/nix-instantiate -))

# Location of Nix boot scripts?
bootPath=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).boot' | $NIX/nix-instantiate -))

nix=$($NIX/nix-store -q $(echo '(import ./pkgs.nix).nixUnstable' | $NIX/nix-instantiate -))

syslinux=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).syslinux' | $NIX/nix-instantiate -))

kernel=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).kernel' | $NIX/nix-instantiate -))

#nixDeps=$($NIX/nix-store -qR $(echo '(import ./pkgs.nix).nix' | $NIX/nix-instantiate -))

#nixDeps=$($NIX/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).nix' | $NIX/nix-instantiate -)))
#echo $($NIX/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).nix' | $NIX/nix-instantiate -))) >> $storePaths
#$NIX/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).nix' | $NIX/nix-instantiate -)) >> $storePaths

for i in $storeExpr
do
  echo $i >> $storePaths
  echo '' >> $storePaths
  deps=$($NIX/nix-store -q --references $i)
  pkgs=$(echo $deps | wc -w)
  echo $pkgs >> $storePaths
  for j in $deps
  do
    echo $j >> $storePaths
  done
  echo copying from store: $i
  tar -cf - $i | tar --directory=$archivesDir -xf -
done

utilLinux=$(nix-store -r $(echo '(import ./pkgs.nix).utillinuxStatic' | $NIX/nix-instantiate -))
coreUtilsDiet=$($NIX/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).coreutilsDiet' | $NIX/nix-instantiate -)))

## temporarily normal e2fsprogs until I can get it to build with dietlibc
e2fsProgs=$($NIX/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).e2fsprogsDiet' | $NIX/nix-instantiate -)))
#e2fsProgs=$($NIX/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).e2fsprogs' | $NIX/nix-instantiate -)))
modUtils=$($NIX/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).module_init_toolsStatic' | $NIX/nix-instantiate -)))
Grub=$($NIX/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).grubWrapper' | $NIX/nix-instantiate -)))
#gnuSed=$($NIX/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).gnused' | $NIX/nix-instantiate -)))
#gnuGrep=$($NIX/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).gnugrep' | $NIX/nix-instantiate -)))
Kernel=$($NIX/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).kernel' | $NIX/nix-instantiate -)))
SysVinit=$($NIX/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).sysvinit' | $NIX/nix-instantiate -)))
BootPath=$($NIX/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).boot' | $NIX/nix-instantiate -)))

bashGlibc=$($NIX/nix-store -q $(echo '(import ./pkgs.nix).bash' | $NIX/nix-instantiate -))
bash=$($NIX/nix-store -q $(echo '(import ./pkgs.nix).bashStatic' | $NIX/nix-instantiate -))
coreutilsdiet=$($NIX/nix-store -q $(echo '(import ./pkgs.nix).coreutilsDiet' | $NIX/nix-instantiate -))
coreutils=$($NIX/nix-store -q $(echo '(import ./pkgs.nix).coreutils' | $NIX/nix-instantiate -))
findutils=$($NIX/nix-store -q $(echo '(import ./pkgs.nix).findutilsWrapper' | $NIX/nix-instantiate -))
utillinux=$($NIX/nix-store -q $(echo '(import ./pkgs.nix).utillinux' | $NIX/nix-instantiate -))
e2fsprogs=$($NIX/nix-store -q $(echo '(import ./pkgs.nix).e2fsprogsDiet' | $NIX/nix-instantiate -))
#e2fsprogs=$($NIX/nix-store -q $(echo '(import ./pkgs.nix).e2fsprogs' | $NIX/nix-instantiate -))
modutils=$($NIX/nix-store -q $(echo '(import ./pkgs.nix).module_init_toolsStatic' | $NIX/nix-instantiate -))
grub=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).grubWrapper' | $NIX/nix-instantiate -))
mingettyWrapper=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).mingettyWrapper' | $NIX/nix-instantiate -))
udev=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).udev' | $NIX/nix-instantiate -))
dhcp=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).dhcpWrapper' | $NIX/nix-instantiate -))
nano=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).nano' | $NIX/nix-instantiate -))
gnugrep=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).gnugrep' | $NIX/nix-instantiate -))
which=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).which' | $NIX/nix-instantiate -))
gnutar=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).gnutar' | $NIX/nix-instantiate -))
eject=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).eject' | $NIX/nix-instantiate -))
sysklogd=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).sysklogd' | $NIX/nix-instantiate -))
#kudzu=$($NIX/nix-store -r $(echo '(import ./pkgs.nix).kudzu' | $NIX/nix-instantiate -))

#(while read storepath; do
   #cp -fa --parents ${storepath} ${archivesDir}
#done) < $storePaths

#echo utillinux $utilLinux

#for i in $utilLinux; do
#  echo i $i
#  deps=( $($NIX/nix-store -q --references $i) )
#  echo length ${#deps[@]}
#  if test "${#deps[@]}" = 0
#  then
#    echo zarro
#  fi
#done

echo creating directories for bootimage

mkdir ${initdir}
mkdir ${initdir}/bin
mkdir ${initdir}/cdrom
mkdir ${initdir}/dev
mkdir ${initdir}/etc
mkdir ${initdir}/etc/sysconfig
mkdir ${initdir}/installimage
mkdir ${initdir}/modules
mkdir ${initdir}/proc
mkdir ${initdir}/sbin
mkdir ${initdir}/sys
mkdir ${initdir}/tmp
mkdir -p ${initdir}/usr/bin
mkdir -p ${initdir}/usr/sbin
mkdir ${initdir}/var
mkdir ${initdir}/var/run

echo copying nixpkgs

#svn export ${nixpkgs} ${archivesDir}/pkgs
cp -fa ${nixpkgs} ${archivesDir}
#tar cf $archivesDir

#echo copying packages from store

#cp -fa --parents ${nixDeps} ${archivesDir}
#cp -fvau --parents ${utilLinux} ${archivesDir}
#cp -fvau --parents ${Grub} ${archivesDir}
##cp -fau --parents ${gnuSed} ${archivesDir}
##cp -fau --parents ${gnuGrep} ${archivesDir}
#cp -fvau --parents ${Kernel} ${archivesDir}
#cp -fvau --parents ${SysVinit} ${archivesDir}
#cp -fvau --parents ${BootPath} ${archivesDir}
#cp -fvau --parents ${udev} ${archivesDir}
#cp -fvau --parents ${dhcp} ${archivesDir}
#cp -fvau --parents ${nano} ${archivesDir}
#cp -fvau --parents ${gnutar} ${archivesDir}

echo copying scripts

mkdir ${archivesDir}/scripts
cp -fa * ${archivesDir}/scripts
sed -e "s^@bash\@^$bash^g" \
    -e "s^@coreutils\@^$coreutilsdiet^g" \
    < $initscript > $initscript.tmp
mv $initscript.tmp $initscript
sed -e "s^@sysvinitPath\@^$sysvinitPath^g" \
    -e "s^@bootPath\@^$bootPath^g" \
    -e "s^@nix\@^$nix^g" \
    -e "s^@bash\@^$bash^g" \
    -e "s^@bashGlibc\@^$bashGlibc^g" \
    -e "s^@findutils\@^$findutils^g" \
    -e "s^@coreutilsdiet\@^$coreutilsdiet^g" \
    -e "s^@coreutils\@^$coreutils^g" \
    -e "s^@utilLinux\@^$utilLinux^g" \
    -e "s^@utillinux\@^$utillinux^g" \
    -e "s^@e2fsprogs\@^$e2fsprogs^g" \
    -e "s^@modutils\@^$modutils^g" \
    -e "s^@grub\@^$grub^g" \
    -e "s^@kernel\@^$kernel^g" \
    -e "s^@gnugrep\@^$gnugrep^g" \
    -e "s^@which\@^$which^g" \
    -e "s^@kudzu\@^$kudzu^g" \
    -e "s^@sysklogd\@^$sysklogd^g" \
    -e "s^@gnutar\@^$gnutar^g" \
    -e "s^@mingetty\@^$mingettyWrapper^g" \
    < $fill_disk > $fill_disk.tmp
mv $fill_disk.tmp $fill_disk

sed -e "s^@sysvinitPath\@^$sysvinitPath^g" \
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
    -e "s^@gnugrep\@^$gnugrep^g" \
    -e "s^@which\@^$which^g" \
    -e "s^@gnutar\@^$gnutar^g" \
    -e "s^@mingetty\@^$mingettyWrapper^g" \
    < $ramdisk_login > $ramdisk_login.tmp
mv $ramdisk_login.tmp $ramdisk_login

echo copying bootimage

mkdir ${archivesDir}/isolinux
cp ${syslinux}/lib/syslinux/isolinux.bin ${archivesDir}/isolinux
cp isolinux.cfg ${archivesDir}/isolinux
chmod u+w ${archivesDir}/isolinux/*

echo copying kernel

# By following the symlink we don't have to know the version number
# of the kernel here.
cp -L $kernel/vmlinuz ${archivesDir}/isolinux

echo linking kernel modules

ln -s $kernel/lib $archivesDir/lib

echo creating ramdisk

rm -f ${initrd}
#cp ${archivesDir}/scripts/fill-disk.sh ${initdir}/init
cp ${archivesDir}/scripts/fill-disk.sh ${initdir}/
cp ${archivesDir}/scripts/ramdisk-login.sh ${initdir}/
cp ${archivesDir}/scripts/init.sh ${initdir}/init
#ln -s ${bash}/bin/bash ${initdir}/bin/sh
cp ${bash}/bin/bash ${initdir}/bin/sh
chmod u+x ${initdir}/init
chmod u+x ${initdir}/fill-disk.sh
chmod u+x ${initdir}/ramdisk-login.sh
#cp -fau --parents ${utilLinux} ${initdir}
#cp -fau --parents ${coreUtilsDiet} ${initdir}
#cp -fau --parents ${modUtils} ${initdir}
cp -fau --parents ${bash}/bin ${initdir}
cp -fau --parents ${utilLinux}/bin ${initdir}
chmod -R u+w ${initdir}
cp -fau --parents ${utilLinux}/sbin ${initdir}
cp -fau --parents ${e2fsProgs} ${initdir}
cp -fau --parents ${coreutilsdiet}/bin ${initdir}
cp -fau --parents ${modutils}/bin ${initdir}
chmod -R u+w ${initdir}
echo modutils
cp -fau --parents ${modutils}/sbin ${initdir}
#cp -fau --parents ${kudzu} ${initdir}

touch ${archivesDir}/NIXOS

(cd ${initdir}; find . |cpio -H newc -o) | gzip -9 > ${initrd}

chmod -f -R +w ${initdir}/*
rm -rf ${initdir}

cp ${initrd} ${archivesDir}/isolinux
rm -f ${initrd}

echo creating ISO image

mkisofs -rJ -o ${bootiso} -b isolinux/isolinux.bin -c isolinux/boot.cat \
                -no-emul-boot -boot-load-size 4 -boot-info-table \
                ${archivesDir}

# cleanup, be diskspace friendly

echo cleaning up

chmod -f -R +w ${archivesDir}/*
#rm -rf ${archivesDir}/*
