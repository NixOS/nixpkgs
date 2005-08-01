#! /bin/sh -e

# deps is an array
declare -a deps

archivesDir=/tmp/arch
manifest=${archivesDir}/MANIFEST
nixpkgs=/nixpkgs/trunk/pkgs
fill_disk=$archivesDir/scripts/fill-disk.sh
storePaths=$archivesDir/mystorepaths
validatePaths=$archivesDir/validatepaths
bootiso=/tmp/nixos.iso
#initrd=/tmp/initrd.img
initrd=/tmp/initram.img

# keep chmod happy
touch ${archivesDir}/blah
chmod -f -R +w ${archivesDir}/*
rm -rf ${archivesDir}/*

NIX_CMD_PATH=/nix/bin

storeExpr=$(echo '(import ./pkgs.nix).everything' | $NIX_CMD_PATH/nix-instantiate -v -v -)
#$NIX_CMD_PATH/nix-push --copy $archivesDir $manifest $(nix-store -r $storeExpr) $(nix-store -r $(echo '(import ./pkgs.nix).kernel' | $NIX_CMD_PATH/nix-instantiate -))

# Location of sysvinit?
sysvinitPath=$($NIX_CMD_PATH/nix-store -q $(echo '(import ./pkgs.nix).sysvinit' | $NIX_CMD_PATH/nix-instantiate -))

# Location of Nix boot scripts?
bootPath=$($NIX_CMD_PATH/nix-store -q $(echo '(import ./pkgs.nix).boot' | $NIX_CMD_PATH/nix-instantiate -))

nix=$($NIX_CMD_PATH/nix-store -q $(echo '(import ./pkgs.nix).nix' | $NIX_CMD_PATH/nix-instantiate -))

syslinux=$($NIX_CMD_PATH/nix-store -q $(echo '(import ./pkgs.nix).syslinux' | $NIX_CMD_PATH/nix-instantiate -))

kernel=$($NIX_CMD_PATH/nix-store -r $(echo '(import ./pkgs.nix).kernel' | $NIX_CMD_PATH/nix-instantiate -))

#nixDeps=$($NIX_CMD_PATH/nix-store -qR $(echo '(import ./pkgs.nix).nix' | $NIX_CMD_PATH/nix-instantiate -))

#nixDeps=$($NIX_CMD_PATH/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).nix' | $NIX_CMD_PATH/nix-instantiate -)))
echo $($NIX_CMD_PATH/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).nix' | $NIX_CMD_PATH/nix-instantiate -))) >> $storePaths

#echo $nixDeps > $storePaths

utilLinux=$($NIX_CMD_PATH/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).utillinux' | $NIX_CMD_PATH/nix-instantiate -)))

bash=$($NIX_CMD_PATH/nix-store -q $(echo '(import ./pkgs.nix).bash' | $NIX_CMD_PATH/nix-instantiate -))

(while read storepath; do
   cp -fa --parents ${storepath} ${archivesDir}
done) < $storePaths

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

mkdir ${archivesDir}/bin
mkdir ${archivesDir}/sbin
mkdir -p ${archivesDir}/usr/bin
mkdir -p ${archivesDir}/usr/sbin
mkdir ${archivesDir}/tmp
mkdir ${archivesDir}/proc
mkdir ${archivesDir}/var
mkdir ${archivesDir}/etc
mkdir ${archivesDir}/dev

echo copying nixpkgs

cp -fa ${nixpkgs} ${archivesDir}

echo copying packges from store

#cp -fa --parents ${nixDeps} ${archivesDir}
cp -fau --parents ${utilLinux} ${archivesDir}

echo bash $bash

echo copying scripts

mkdir ${archivesDir}/scripts
cp -fa * ${archivesDir}/scripts
sed -e "s^@sysvinitPath\@^$sysvinitPath^g" \
    -e "s^@bootPath\@^$bootPath^g" \
    -e "s^@NIX_CMD_PATH\@^$nix^g" \
    -e "s^@bash\@^$bash^g" \
    < $fill_disk > $fill_disk.tmp
mv $fill_disk.tmp $fill_disk

echo copying bootimage

mkdir ${archivesDir}/isolinux
cp ${syslinux}/lib/syslinux/isolinux.bin ${archivesDir}/isolinux
cp isolinux.cfg ${archivesDir}/isolinux
chmod u+w ${archivesDir}/isolinux/*

echo copying kernel

# By following the symlink we don't have to know the version number
# of the kernel here.
cp -L $kernel/vmlinuz ${archivesDir}/isolinux

# echo making ramdisk
# todo!
# mkdir ${archivesDir}/sbin
# ln -s /scripts/fill-disk.sh ${archivesDir}/sbin/init
ln -s /scripts/fill-disk.sh ${archivesDir}/init

echo creating ramdisk

rm -f ${initrd}
(cd ${archivesDir}; find . |cpio -c -o) | gzip -9 > ${initrd}

#mkcramfs ${archivesDir} /tmp/initramdisk.img

cp ${initrd} ${archivesDir}/isolinux

echo creating ISO image

mkisofs -rJ -o ${bootiso} -b isolinux/isolinux.bin -c isolinux/boot.cat \
                -no-emul-boot -boot-load-size 4 -boot-info-table \
                ${archivesDir}
