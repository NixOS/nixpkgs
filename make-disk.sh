#! /bin/sh -e

archivesDir=/tmp/arch
manifest=${archivesDir}/MANIFEST
nixpkgs=/nixpkgs2/trunk/pkgs
fill_disk=$archivesDir/scripts/fill-disk.sh

rm -rf ${archivesDir}/*

NIX_CMD_PATH=/nix/bin

storeExpr=$(echo '(import ./pkgs.nix).everything' | $NIX_CMD_PATH/nix-instantiate -v -v -)
$NIX_CMD_PATH/nix-push --copy $archivesDir $manifest $(nix-store -r $storeExpr) $(nix-store -r $(echo '(import ./pkgs.nix).kernel' | $NIX_CMD_PATH/nix-instantiate -))

# Location of sysvinit?
sysvinitPath=$($NIX_CMD_PATH/nix-store -q $(echo '(import ./pkgs.nix).sysvinit' | $NIX_CMD_PATH/nix-instantiate -))

# Location of Nix boot scripts?
bootPath=$($NIX_CMD_PATH/nix-store -q $(echo '(import ./pkgs.nix).boot' | $NIX_CMD_PATH/nix-instantiate -))

echo "bootPath: ${bootPath}"

cp -fa ${nixpkgs} ${archivesDir}
mkdir ${archivesDir}/scripts
cp -fa * ${archivesDir}/scripts
sed -e "s^@sysvinitPath\@^$sysvinitPath^g" \
    -e "s^@bootPath\@^$bootPath^g" \
    < $fill_disk > $fill_disk.tmp
mv $fill_disk.tmp $fill_disk
