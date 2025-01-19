#! /usr/bin/env nix-shell
#! nix-shell ../../../applications/editors/vscode/update-shell.nix -i bash

# Update script for the vscode versions and hashes.
# Usually doesn't need to be called by hand,
# but is called by a bot: https://github.com/samuela/nixpkgs-upkeep/actions
# Call it by hand if the bot fails to automatically update the versions.

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
if [ ! -f "$ROOT/package.nix" ]; then
  echo "ERROR: cannot find package.nix in $ROOT"
  exit 1
fi

update_aide_ide () {
  AIDE_VER=$1
  ARCH=$2
  ARCH_LONG=$3
  ARCHIVE_FMT=$4
  AIDE_URL="https://github.com/codestoryai/binaries/releases/download/${AIDE_VER}/Aide-${ARCH}-${AIDE_VER}.${ARCHIVE_FMT}"
  AIDE_SHA256=$(nix-prefetch-url ${AIDE_URL})
  sed -i "s/${ARCH_LONG} = \"[0-9a-zA-Z]\{40,64\}\"/${ARCH_LONG} = \"${AIDE_SHA256}\"/" "$ROOT/package.nix"
}

# VSCodium

AIDE_VER=$(curl -Ls -w %{url_effective} -o /dev/null https://github.com/codestoryai/binaries/releases/latest | awk -F'/' '{print $NF}')
sed -i "s/version = \".*\"/version = \"${AIDE_VER}\"/" "$ROOT/package.nix"

update_aide_ide $AIDE_VER linux-x64 x86_64-linux tar.gz

update_aide_ide $AIDE_VER darwin-x64 x86_64-darwin zip

update_aide_ide $AIDE_VER linux-arm64 aarch64-linux tar.gz

update_aide_ide $AIDE_VER darwin-arm64 aarch64-darwin zip

update_aide_ide $AIDE_VER linux-armhf armv7l-linux tar.gz
