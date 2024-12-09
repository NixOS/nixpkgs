#! /usr/bin/env nix-shell
#! nix-shell update-shell.nix -i bash

# Update script for the vscode versions and hashes.
# Usually doesn't need to be called by hand,
# but is called by a bot: https://github.com/samuela/nixpkgs-upkeep/actions
# Call it by hand if the bot fails to automatically update the versions.

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
if [ ! -f "$ROOT/vscodium.nix" ]; then
  echo "ERROR: cannot find vscodium.nix in $ROOT"
  exit 1
fi

update_vscodium () {
  VSCODIUM_VER=$1
  ARCH=$2
  ARCH_LONG=$3
  ARCHIVE_FMT=$4
  VSCODIUM_URL="https://github.com/VSCodium/vscodium/releases/download/${VSCODIUM_VER}/VSCodium-${ARCH}-${VSCODIUM_VER}.${ARCHIVE_FMT}"
  VSCODIUM_SHA256=$(nix-prefetch-url ${VSCODIUM_URL})
  sed -i "s/${ARCH_LONG} = \"[0-9a-fA-F]\{40,64\}\"/${ARCH_LONG} = \"${VSCODIUM_SHA256}\"/" "$ROOT/vscodium.nix"
}

# VSCodium

VSCODIUM_VER=$(curl -Ls -w %{url_effective} -o /dev/null https://github.com/VSCodium/vscodium/releases/latest | awk -F'/' '{print $NF}')
sed -i "s/version = \".*\"/version = \"${VSCODIUM_VER}\"/" "$ROOT/vscodium.nix"

update_vscodium $VSCODIUM_VER linux-x64 x86_64-linux tar.gz

update_vscodium $VSCODIUM_VER darwin-x64 x86_64-darwin zip

update_vscodium $VSCODIUM_VER linux-arm64 aarch64-linux tar.gz

update_vscodium $VSCODIUM_VER darwin-arm64 aarch64-darwin zip

update_vscodium $VSCODIUM_VER linux-armhf armv7l-linux tar.gz
