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

# VSCodium

VSCODIUM_VER=$(curl -Ls -w %{url_effective} -o /dev/null https://github.com/VSCodium/vscodium/releases/latest | awk -F'/' '{print $NF}')
sed -i "s/version = \".*\"/version = \"${VSCODIUM_VER}\"/" "$ROOT/vscodium.nix"

VSCODIUM_LINUX_X64_URL="https://github.com/VSCodium/vscodium/releases/download/${VSCODIUM_VER}/VSCodium-linux-x64-${VSCODIUM_VER}.tar.gz"
VSCODIUM_LINUX_X64_SHA256=$(nix-prefetch-url ${VSCODIUM_LINUX_X64_URL})
sed -i "s/x86_64-linux = \".\{52\}\"/x86_64-linux = \"${VSCODIUM_LINUX_X64_SHA256}\"/" "$ROOT/vscodium.nix"

VSCODIUM_DARWIN_X64_URL="https://github.com/VSCodium/vscodium/releases/download/${VSCODIUM_VER}/VSCodium-darwin-x64-${VSCODIUM_VER}.zip"
VSCODIUM_DARWIN_X64_SHA256=$(nix-prefetch-url ${VSCODIUM_DARWIN_X64_URL})
sed -i "s/x86_64-darwin = \".\{52\}\"/x86_64-darwin = \"${VSCODIUM_DARWIN_X64_SHA256}\"/" "$ROOT/vscodium.nix"

VSCODIUM_LINUX_AARCH64_URL="https://github.com/VSCodium/vscodium/releases/download/${VSCODIUM_VER}/VSCodium-linux-arm64-${VSCODIUM_VER}.tar.gz"
VSCODIUM_LINUX_AARCH64_SHA256=$(nix-prefetch-url ${VSCODIUM_LINUX_AARCH64_URL})
sed -i "s/aarch64-linux = \".\{52\}\"/aarch64-linux = \"${VSCODIUM_LINUX_AARCH64_SHA256}\"/" "$ROOT/vscodium.nix"

VSCODIUM_LINUX_ARMV7L_URL="https://github.com/VSCodium/vscodium/releases/download/${VSCODIUM_VER}/VSCodium-linux-armhf-${VSCODIUM_VER}.tar.gz"
VSCODIUM_LINUX_ARMV7L_SHA256=$(nix-prefetch-url ${VSCODIUM_LINUX_ARMV7L_URL})
sed -i "s/armv7l-linux = \".\{52\}\"/armv7l-linux = \"${VSCODIUM_LINUX_ARMV7L_SHA256}\"/" "$ROOT/vscodium.nix"
