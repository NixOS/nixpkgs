#! /bin/sh -e

archivesDir=/tmp/arch
manifest=${archivesDir}/MANIFEST
nixpkgs=/nixpkgs/trunk/pkgs

NIX_CMD_PATH=/nix/bin

storeExpr=$(echo '(import ./pkgs.nix).everything' | $NIX_CMD_PATH/nix-instantiate -v -v -)
$NIX_CMD_PATH/nix-push --copy $archivesDir $manifest $(nix-store -r $storeExpr) $(nix-store -r $(echo '(import ./pkgs.nix).kernel' | $NIX_CMD_PATH/nix-instantiate -))
#$NIX_CMD_PATH/nix-push --copy $archivesDir $manifest $(nix-store -r $(echo '(import ./pkgs.nix).kernel' | $NIX_CMD_PATH/nix-instantiate -))

# Location of sysvinit?
#sysvinitPath=$($NIX_CMD_PATH/nix-store -q $(echo '(import ./pkgs.nix).sysvinit' | $NIX_CMD_PATH/nix-instantiate -))

# Location of Nix boot scripts?
#bootPath=$($NIX_CMD_PATH/nix-store -q $(echo '(import ./pkgs.nix).boot' | $NIX_CMD_PATH/nix-instantiate -))

cp -a ${nixpkgs} ${archivesDir}
