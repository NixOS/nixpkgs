#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl nix
#
# Update script for nixpkgs' automated update infrastructure.
#
# nixpkgs-update (r-ryantm bot) runs this via passthru.updateScript.
# It can also be run manually:
#   ./update.sh
#
set -euo pipefail

GCS_BUCKET="https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases"
PACKAGE_NIX="$(dirname "$0")/package.nix"

# 1. Get latest version
version=$(curl -fsSL "$GCS_BUCKET/latest")
echo "Latest version: $version"

# 2. Get manifest
manifest=$(curl -fsSL "$GCS_BUCKET/$version/manifest.json")

# 3. Extract hex checksums and convert to SRI
declare -A PLATFORM_MAP=(
  [x86_64-linux]="linux-x64"
  [aarch64-linux]="linux-arm64"
  [x86_64-darwin]="darwin-x64"
  [aarch64-darwin]="darwin-arm64"
)

for nix_system in "${!PLATFORM_MAP[@]}"; do
  gcs_platform="${PLATFORM_MAP[$nix_system]}"

  hex=$(echo "$manifest" | grep -A2 "\"$gcs_platform\"" | grep '"checksum"' | sed 's/.*"\([a-f0-9]\{64\}\)".*/\1/')

  if [ -z "$hex" ]; then
    echo "WARNING: no checksum found for $gcs_platform" >&2
    continue
  fi

  sri=$(nix-hash --to-sri --type sha256 "$hex")
  echo "  $nix_system ($gcs_platform): $sri"

  sed -i "/$nix_system = {/,/};/{s|hash = \"sha256-[^\"]*\"|hash = \"$sri\"|}" "$PACKAGE_NIX"
done

# 4. Update version
sed -i "s/version = \"[^\"]*\"/version = \"$version\"/" "$PACKAGE_NIX"

echo "Updated package.nix to version $version"
