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
  IS_INSIDERS=$2
  ARCH=$3
  ARCH_LONG=$4
  ARCHIVE_FMT=$5
  CHANNEL=$($IS_INSIDERS && echo "insider" || echo "stable")
  CHANNEL_SUFFIX=$($IS_INSIDERS && echo "-insiders" || echo "")
  VSCODIUM_URL="https://github.com/VSCodium/vscodium${CHANNEL_SUFFIX}/releases/download/${VSCODIUM_VER}/VSCodium-${ARCH}-${VSCODIUM_VER}.${ARCHIVE_FMT}"
  VSCODIUM_SHA256=$(nix-prefetch-url ${VSCODIUM_URL})
  sed -i "s/${CHANNEL}-${ARCH_LONG} = \".\{52\}\"/${CHANNEL}-${ARCH_LONG} = \"${VSCODIUM_SHA256}\"/" "$ROOT/vscodium.nix"
}

# VSCodium

VSCODIUM_STABLE_VER=$(curl -Ls -w %{url_effective} -o /dev/null https://github.com/VSCodium/vscodium/releases/latest | awk -F'/' '{print $NF}')
VSCODIUM_INSIDERS_VER=$(curl -Ls -w %{url_effective} -o /dev/null https://github.com/VSCodium/vscodium-insiders/releases/latest | awk -F'/' '{print $NF}')
sed -i "s/version = if isInsiders then \".*\" else \".*\"/version = if isInsiders then \"${VSCODIUM_INSIDERS_VER}\" else \"${VSCODIUM_STABLE_VER}\"/" "$ROOT/vscodium.nix"

update_vscodium $VSCODIUM_STABLE_VER false linux-x64 x86_64-linux tar.gz
update_vscodium $VSCODIUM_STABLE_VER false darwin-x64 x86_64-darwin zip
update_vscodium $VSCODIUM_STABLE_VER false linux-arm64 aarch64-linux tar.gz
update_vscodium $VSCODIUM_STABLE_VER false darwin-arm64 aarch64-darwin zip
update_vscodium $VSCODIUM_STABLE_VER false linux-armhf armv7l-linux tar.gz

update_vscodium $VSCODIUM_INSIDERS_VER true linux-x64 x86_64-linux tar.gz
update_vscodium $VSCODIUM_INSIDERS_VER true darwin-x64 x86_64-darwin zip
update_vscodium $VSCODIUM_INSIDERS_VER true linux-arm64 aarch64-linux tar.gz
update_vscodium $VSCODIUM_INSIDERS_VER true darwin-arm64 aarch64-darwin zip
update_vscodium $VSCODIUM_INSIDERS_VER true linux-armhf armv7l-linux tar.gz
