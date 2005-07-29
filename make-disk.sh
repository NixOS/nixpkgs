#! /bin/sh -e

declare -a deps

archivesDir=/tmp/arch
manifest=${archivesDir}/MANIFEST
nixpkgs=/nixpkgs/trunk/pkgs
fill_disk=$archivesDir/scripts/fill-disk.sh
storePaths=$archivesDir/mystorepaths
validatePaths=$archivesDir/validatepaths

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

#nixDeps=$($NIX_CMD_PATH/nix-store -qR $(echo '(import ./pkgs.nix).nix' | $NIX_CMD_PATH/nix-instantiate -))

#nixDeps=$($NIX_CMD_PATH/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).nix' | $NIX_CMD_PATH/nix-instantiate -)))
echo $($NIX_CMD_PATH/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).nix' | $NIX_CMD_PATH/nix-instantiate -))) >> $storePaths

#echo $nixDeps > $storePaths

utilLinux=$($NIX_CMD_PATH/nix-store -qR $(nix-store -r $(echo '(import ./pkgs.nix).utillinux' | $NIX_CMD_PATH/nix-instantiate -)))

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

cp -fa ${nixpkgs} ${archivesDir}
#cp -fa --parents ${nixDeps} ${archivesDir}
cp -fau --parents ${utilLinux} ${archivesDir}
mkdir ${archivesDir}/scripts
cp -fa * ${archivesDir}/scripts
sed -e "s^@sysvinitPath\@^$sysvinitPath^g" \
    -e "s^@bootPath\@^$bootPath^g" \
    -e "s^@NIX_CMD_PATH\@^$nix^g" \
    < $fill_disk > $fill_disk.tmp
mv $fill_disk.tmp $fill_disk
