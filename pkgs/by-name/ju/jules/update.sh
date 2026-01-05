#!/usr/bin/env nix
#!nix shell --ignore-environment .#cacert .#nodejs .#git .#nix-update .#nix .#gnused .#findutils .#bash .#curl .#jq --command bash

set -euo pipefail

version=$(npm view @google/jules version)

# Update version and hashes for the npm package
NIXPKGS_ALLOW_UNFREE=1 nix-update jules --version="$version" --generate-lockfile

# Update the binary hashes for all platforms
declare -A platforms=(
  ["x86_64-linux"]="linux_amd64"
  ["aarch64-linux"]="linux_arm64"
  ["x86_64-darwin"]="darwin_amd64"
  ["aarch64-darwin"]="darwin_arm64"
)

for nix_platform in "${!platforms[@]}"; do
  binary_suffix="${platforms[$nix_platform]}"
  binary_url="https://storage.googleapis.com/jules-cli/v${version}/jules_external_v${version}_${binary_suffix}.tar.gz"
  binary_hash=$(nix-prefetch-url "$binary_url" 2>/dev/null | xargs nix hash convert --hash-algo sha256 --to sri)
  # Update the hash for this platform
  sed -i "/${nix_platform}/,/hash = /s|hash = \"sha256-[^\"]*\"|hash = \"${binary_hash}\"|" pkgs/by-name/ju/jules/package.nix
done

# Update the version in the binary URL pattern
sed -i "s|jules_external_v[0-9.]*_|jules_external_v${version}_|g" pkgs/by-name/ju/jules/package.nix

# nix-update can't update package-lock.json along with npmDepsHash
# TODO: Remove this workaround if nix-update can update package-lock.json along with npmDepsHash.
(nix-build --expr '((import ./.) { system = builtins.currentSystem; }).jules.npmDeps.overrideAttrs { outputHash = ""; outputHashAlgo = "sha256"; }' 2>&1 || true) \
| sed -nE '$s/ *got: *(sha256-[A-Za-z0-9+/=-]+).*/\1/p' \
| xargs -I{} sed -i 's|npmDepsHash = "sha256-[^"]*";|npmDepsHash = "{}";|' pkgs/by-name/ju/jules/package.nix
