#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused gawk nix-prefetch jq dotnet-sdk_8 nuget-to-nix

set -euo pipefail
URL="https://github.com/microsoft/artifacts-credprovider"

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/package.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find package.nix in $ROOT"
  exit 1
fi

TMP="$(mktemp -d)"
clean_up() {
    rm -rf "$TMP"
}
trap clean_up EXIT SIGINT SIGTERM
PACKAGES="$TMP/packages"
SRC_RW="$TMP/src"

mkdir -p $SRC_RW
mkdir -p $PACKAGES


VER=$(curl -s "https://api.github.com/repos/microsoft/artifacts-credprovider/releases/latest" | jq -r .tag_name | grep -oP '\d+\.\d+\.\d+' )
HASH=$(nix-hash --to-sri --type sha256 "$(nix-prefetch-git --url $URL --rev "v$VER" --quiet | jq -r .sha256)")

sed -i "s/version = \".*\"/version = \"$VER\"/" "$NIX_DRV"
sed -i "s#sha256 = \"sha256-.\{44\}\"#sha256 = \"$HASH\"#" "$NIX_DRV"

nix-prefetch-git --url $URL --rev "v$VER" --out $SRC_RW --builder --quiet
rm $SRC_RW/nuget.config
dotnet restore "$SRC_RW/MicrosoftCredentialProvider.sln" --packages $PACKAGES -r:linux-x64
nuget-to-nix $PACKAGES > deps.nix
