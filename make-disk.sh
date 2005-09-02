#! /bin/sh -e

# deps is an array
declare -a deps

archivesDir=/tmp/arch
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

echo cleaning old build

# keep chmod happy
touch ${archivesDir}/blah
chmod -f -R +w ${archivesDir}/*
rm -rf ${archivesDir}/*

NIX_CMD_PATH=$(dirname $(which nix-store))

storeExpr=$($NIX_CMD_PATH/nix-store -qR $($NIX_CMD_PATH/nix-store -r $(echo '(import ./pkgs.nix).everything' | $NIX_CMD_PATH/nix-instantiate -)))
#$NIX_CMD_PATH/nix-push --copy $archivesDir $manifest $(nix-store -r $storeExpr) $(nix-store -r $(echo '(import ./pkgs.nix).kernel' | $NIX_CMD_PATH/nix-instantiate -))

# Location of sysvinit?
sysvinitPath=$($NIX_CMD_PATH/nix-store -r $(echo '(import ./pkgs.nix).sysvinit' | $NIX_CMD_PATH/nix-instantiate -))

# Location of Nix boot scripts?
bootPath=$($NIX_CMD_PATH/nix-store -r $(echo '(import ./pkgs.nix).boot' | $NIX_CMD_PATH/nix-instantiate -))

nix=$($NIX_CMD_PATH/nix-store -q $(echo '(import ./pkgs.nix).nix' | $NIX_CMD_PATH/nix-instantiate -))

syslinux=$($NIX_CMD_PATH/nix-store -r $(echo '(import ./pkgs.nix).syslinux' | $NIX_CMD_PATH/nix-instantiate -))

kernel=$($NIX_CMD_PATH/nix-store -r $(echo '(import ./pkgs.nix).kernel' | $NIX_CMD_PATH/nix-instantiate -))

#nixDeps=$($NIX_CMD_PATH/nix-store -qR $(echo '(import ./pkgs.nix).nix' | $NIX_CMD_PATH/nix-instantiate -))

#nixDeps=$($NIX_CMD_PATH/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).nix' | $NIX_CMD_PATH/nix-instantiate -)))
#echo $($NIX_CMD_PATH/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).nix' | $NIX_CMD_PATH/nix-instantiate -))) >> $storePaths
#$NIX_CMD_PATH/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).nix' | $NIX_CMD_PATH/nix-instantiate -)) >> $storePaths

for i in $storeExpr
do
  echo $i >> $storePaths
  echo '' >> $storePaths
  deps=$($NIX_CMD_PATH/nix-store -q --references $i)
  pkgs=$(echo $deps | wc -w)
  echo $pkgs >> $storePaths
  for j in $deps
  do
    echo $j >> $storePaths
  done
  echo copying from store: $i
  tar -cf - $i | tar --directory=$archivesDir -xf -
done

utilLinux=$($NIX_CMD_PATH/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).utillinux' | $NIX_CMD_PATH/nix-instantiate -)))
coreUtilsDiet=$($NIX_CMD_PATH/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).coreutilsDiet' | $NIX_CMD_PATH/nix-instantiate -)))
e2fsProgs=$($NIX_CMD_PATH/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).e2fsprogsDiet' | $NIX_CMD_PATH/nix-instantiate -)))
modUtils=$($NIX_CMD_PATH/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).module_init_tools' | $NIX_CMD_PATH/nix-instantiate -)))
Grub=$($NIX_CMD_PATH/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).grubWrapper' | $NIX_CMD_PATH/nix-instantiate -)))
#gnuSed=$($NIX_CMD_PATH/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).gnused' | $NIX_CMD_PATH/nix-instantiate -)))
#gnuGrep=$($NIX_CMD_PATH/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).gnugrep' | $NIX_CMD_PATH/nix-instantiate -)))
Kernel=$($NIX_CMD_PATH/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).kernel' | $NIX_CMD_PATH/nix-instantiate -)))
SysVinit=$($NIX_CMD_PATH/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).sysvinit' | $NIX_CMD_PATH/nix-instantiate -)))
BootPath=$($NIX_CMD_PATH/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).boot' | $NIX_CMD_PATH/nix-instantiate -)))

bash=$($NIX_CMD_PATH/nix-store -q $(echo '(import ./pkgs.nix).bash' | $NIX_CMD_PATH/nix-instantiate -))
coreutilsdiet=$($NIX_CMD_PATH/nix-store -q $(echo '(import ./pkgs.nix).coreutilsDiet' | $NIX_CMD_PATH/nix-instantiate -))
coreutils=$($NIX_CMD_PATH/nix-store -q $(echo '(import ./pkgs.nix).coreutils' | $NIX_CMD_PATH/nix-instantiate -))
findutils=$($NIX_CMD_PATH/nix-store -q $(echo '(import ./pkgs.nix).findutilsWrapper' | $NIX_CMD_PATH/nix-instantiate -))
utillinux=$($NIX_CMD_PATH/nix-store -q $(echo '(import ./pkgs.nix).utillinux' | $NIX_CMD_PATH/nix-instantiate -))
e2fsprogs=$($NIX_CMD_PATH/nix-store -q $(echo '(import ./pkgs.nix).e2fsprogsDiet' | $NIX_CMD_PATH/nix-instantiate -))
modutils=$($NIX_CMD_PATH/nix-store -q $(echo '(import ./pkgs.nix).module_init_tools' | $NIX_CMD_PATH/nix-instantiate -))
grub=$($NIX_CMD_PATH/nix-store -r $(echo '(import ./pkgs.nix).grubWrapper' | $NIX_CMD_PATH/nix-instantiate -))
mingettyWrapper=$($NIX_CMD_PATH/nix-store -r $(echo '(import ./pkgs.nix).mingettyWrapper' | $NIX_CMD_PATH/nix-instantiate -))
hotplug=$($NIX_CMD_PATH/nix-store -r $(echo '(import ./pkgs.nix).hotplug' | $NIX_CMD_PATH/nix-instantiate -))
udev=$($NIX_CMD_PATH/nix-store -r $(echo '(import ./pkgs.nix).udev' | $NIX_CMD_PATH/nix-instantiate -))
dhcp=$($NIX_CMD_PATH/nix-store -r $(echo '(import ./pkgs.nix).dhcpWrapper' | $NIX_CMD_PATH/nix-instantiate -))
nano=$($NIX_CMD_PATH/nix-store -r $(echo '(import ./pkgs.nix).nano' | $NIX_CMD_PATH/nix-instantiate -))
gnugrep=$($NIX_CMD_PATH/nix-store -r $(echo '(import ./pkgs.nix).gnugrep' | $NIX_CMD_PATH/nix-instantiate -))
which=$($NIX_CMD_PATH/nix-store -r $(echo '(import ./pkgs.nix).which' | $NIX_CMD_PATH/nix-instantiate -))
gnutar=$($NIX_CMD_PATH/nix-store -r $(echo '(import ./pkgs.nix).gnutar' | $NIX_CMD_PATH/nix-instantiate -))
eject=$($NIX_CMD_PATH/nix-store -r $(echo '(import ./pkgs.nix).eject' | $NIX_CMD_PATH/nix-instantiate -))

#(while read storepath; do
   #cp -fa --parents ${storepath} ${archivesDir}
#done) < $storePaths

echo utillinux $utilLinux

for i in $utilLinux; do
  echo i $i
  deps=( $($NIX_CMD_PATH/nix-store -q --references $i) )
  echo length ${#deps[@]}
  if test "${#deps[@]}" = 0
  then
    echo zarro
  fi
done

echo creating directories for bootimage

mkdir ${initdir}
mkdir ${initdir}/bin
mkdir ${initdir}/cdrom
mkdir ${initdir}/dev
mkdir ${initdir}/etc
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

svn export ${nixpkgs} ${archivesDir}/pkgs
#cp -fa ${nixpkgs} ${archivesDir}

#echo copying packages from store

#cp -fa --parents ${nixDeps} ${archivesDir}
#cp -fvau --parents ${utilLinux} ${archivesDir}
#cp -fvau --parents ${Grub} ${archivesDir}
##cp -fau --parents ${gnuSed} ${archivesDir}
##cp -fau --parents ${gnuGrep} ${archivesDir}
#cp -fvau --parents ${Kernel} ${archivesDir}
#cp -fvau --parents ${SysVinit} ${archivesDir}
#cp -fvau --parents ${BootPath} ${archivesDir}
#cp -fvau --parents ${hotplug} ${archivesDir}
#cp -fvau --parents ${udev} ${archivesDir}
#cp -fvau --parents ${dhcp} ${archivesDir}
#cp -fvau --parents ${nano} ${archivesDir}
#cp -fvau --parents ${gnutar} ${archivesDir}

bashdeps=$($NIX_CMD_PATH/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).bash' | $NIX_CMD_PATH/nix-instantiate -)))

echo copying scripts

mkdir ${archivesDir}/scripts
cp -fa * ${archivesDir}/scripts
sed -e "s^@bash\@^$bash^g" \
    -e "s^@coreutils\@^$coreutilsdiet^g" \
    < $initscript > $initscript.tmp
mv $initscript.tmp $initscript
sed -e "s^@sysvinitPath\@^$sysvinitPath^g" \
    -e "s^@bootPath\@^$bootPath^g" \
    -e "s^@NIX_CMD_PATH\@^$nix^g" \
    -e "s^@bash\@^$bash^g" \
    -e "s^@findutils\@^$findutils^g" \
    -e "s^@coreutilsdiet\@^$coreutilsdiet^g" \
    -e "s^@coreutils\@^$coreutils^g" \
    -e "s^@utillinux\@^$utillinux^g" \
    -e "s^@e2fsprogs\@^$e2fsprogs^g" \
    -e "s^@modutils\@^$modutils^g" \
    -e "s^@grub\@^$grub^g" \
    -e "s^@kernel\@^$kernel^g" \
    -e "s^@hotplug\@^$hotplug^g" \
    -e "s^@gnugrep\@^$gnugrep^g" \
    -e "s^@which\@^$which^g" \
    -e "s^@eject\@^$eject^g" \
    -e "s^@gnutar\@^$gnutar^g" \
    -e "s^@mingetty\@^$mingettyWrapper^g" \
    < $fill_disk > $fill_disk.tmp
mv $fill_disk.tmp $fill_disk

sed -e "s^@sysvinitPath\@^$sysvinitPath^g" \
    -e "s^@bootPath\@^$bootPath^g" \
    -e "s^@NIX_CMD_PATH\@^$nix^g" \
    -e "s^@bash\@^$bash^g" \
    -e "s^@findutils\@^$findutils^g" \
    -e "s^@coreutilsdiet\@^$coreutilsdiet^g" \
    -e "s^@coreutils\@^$coreutils^g" \
    -e "s^@utillinux\@^$utillinux^g" \
    -e "s^@e2fsprogs\@^$e2fsprogs^g" \
    -e "s^@modutils\@^$modutils^g" \
    -e "s^@grub\@^$grub^g" \
    -e "s^@kernel\@^$kernel^g" \
    -e "s^@hotplug\@^$hotplug^g" \
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

echo creating ramdisk

rm -f ${initrd}
#cp ${archivesDir}/scripts/fill-disk.sh ${initdir}/init
cp ${archivesDir}/scripts/fill-disk.sh ${initdir}/
cp ${archivesDir}/scripts/ramdisk-login.sh ${initdir}/
cp ${archivesDir}/scripts/init.sh ${initdir}/init
ln -s ${bash}/bin/bash ${initdir}/bin/sh
chmod u+x ${initdir}/init
chmod u+x ${initdir}/fill-disk.sh
chmod u+x ${initdir}/ramdisk-login.sh
cp -fau --parents ${bashdeps} ${initdir}
cp -fau --parents ${utilLinux} ${initdir}
cp -fau --parents ${coreUtilsDiet} ${initdir}
cp -fau --parents ${e2fsProgs} ${initdir}
cp -fau --parents ${modUtils} ${initdir}
cp -fau --parents ${hotplug} ${initdir}
cp -fau --parents ${eject} ${initdir}

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
rm -rf ${archivesDir}/*
