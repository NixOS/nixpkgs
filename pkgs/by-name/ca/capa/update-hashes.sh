#! /usr/bin/env nix-shell
#! nix-shell -p gnugrep gnused nix-prefetch-git jq -i bash
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz
# shellcheck shell=bash

# Extract version from package.nix
capa_version=$(grep -oE 'version = "([^"]*)"' package.nix | grep -oE '[0-9.]+')

# Exit if failed to grab version
echo "${capa_version}" | grep -qoE '[0-9.]+' || {
  echo "Failed to extract version from package.nix"
  exit 1
}

baseUrl="https://github.com/mandiant/capa"

macosArchive="${baseUrl}/releases/download/v${capa_version}/capa-v${capa_version}-macos.zip"
linuxArchive="${baseUrl}/releases/download/v${capa_version}/capa-v${capa_version}-linux.zip"

darwinHash="$(nix hash convert --hash-algo sha256 --from nix32 $(nix-prefetch-url --type sha256 ${macosArchive}))"
linuxHash="$(nix hash convert --hash-algo sha256 --from nix32 $(nix-prefetch-url --type sha256 ${linuxArchive}))"

sed -i "s|linuxHash = \".*\";|linuxHash = \"${linuxHash}\";|" package.nix
sed -i "s|darwinHash = \".*\";|darwinHash = \"${darwinHash}\";|" package.nix

