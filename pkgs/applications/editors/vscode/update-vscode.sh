#! /usr/bin/env nix-shell
#! nix-shell update-shell.nix -i bash

# Update script for the vscode versions and hashes.
# Usually doesn't need to be called by hand,
# but is called by a bot: https://github.com/samuela/nixpkgs-upkeep/actions
# Call it by hand if the bot fails to automatically update the versions.

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
if [ ! -f "$ROOT/vscode.nix" ]; then
  echo "ERROR: cannot find vscode.nix in $ROOT"
  exit 1
fi

update_vscode () {
  VSCODE_VER=$1
  IS_INSIDERS=$2
  ARCH=$3
  ARCH_LONG=$4
  CHANNEL=$($IS_INSIDERS && echo "insider" || echo "stable")
  VSCODE_URL="https://update.code.visualstudio.com/${VSCODE_VER}/${ARCH}/${CHANNEL}"
  VSCODE_SHA256=$(nix-prefetch-url ${VSCODE_URL})
  sed -i "s/${CHANNEL}-${ARCH_LONG} = \".\{52\}\"/${CHANNEL}-${ARCH_LONG} = \"${VSCODE_SHA256}\"/" "$ROOT/vscode.nix"
}

# VSCode

VSCODE_STABLE_VER=$(curl --fail --silent https://update.code.visualstudio.com/api/releases/stable | jq --raw-output .[0])
VSCODE_INSIDERS_VER=$(curl --fail --silent https://update.code.visualstudio.com/api/releases/insider | jq --raw-output .[0])
sed -i "s/version = if isInsiders then \".*\" else \".*\"/version = if isInsiders then \"${VSCODE_INSIDERS_VER}\" else \"${VSCODE_STABLE_VER}\"/" "$ROOT/vscode.nix"

update_vscode $VSCODE_STABLE_VER false linux-x64 x86_64-linux
update_vscode $VSCODE_STABLE_VER false darwin x86_64-darwin
update_vscode $VSCODE_STABLE_VER false linux-arm64 aarch64-linux
update_vscode $VSCODE_STABLE_VER false darwin-arm64 aarch64-darwin
update_vscode $VSCODE_STABLE_VER false linux-armhf armv7l-linux

update_vscode $VSCODE_INSIDERS_VER true linux-x64 x86_64-linux
update_vscode $VSCODE_INSIDERS_VER true darwin x86_64-darwin
update_vscode $VSCODE_INSIDERS_VER true linux-arm64 aarch64-linux
update_vscode $VSCODE_INSIDERS_VER true darwin-arm64 aarch64-darwin
update_vscode $VSCODE_INSIDERS_VER true linux-armhf armv7l-linux
