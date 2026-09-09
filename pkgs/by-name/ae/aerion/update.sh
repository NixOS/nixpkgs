#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix nix-update nix-prefetch-scripts common-updater-scripts

set -euo pipefail

nixpkgs="$(git rev-parse --show-toplevel)"
aerion_creds_file="$nixpkgs/pkgs/by-name/ae/aerion-creds/package.nix"

version=$(list-git-tags --url=https://github.com/hkdb/aerion \
  | grep -oP '^v\d+\.\d+\.\d+$' \
  | sed 's/^v//' \
  | sort -V \
  | tail -1)

echo "Updating aerion and aerion-creds to v$version"

# Update version in creds file
sed -i "s/version = \".*\";/version = \"$version\";/" "$aerion_creds_file"

# Update creds binary hashes
for arch in x86_64 aarch64; do
    url="https://github.com/hkdb/aerion/releases/download/v$version/flathub-build-env-v$version-linux-$arch"
    echo "  Fetching creds hash for $arch..."
    hash=$(nix-prefetch-url --type sha256 "$url")
    sri_hash=$(nix-hash --to-sri --type sha256 "$hash")
    sed -i "s|\"$arch\" = \"sha256-[^\"]*\";|\"$arch\" = \"$sri_hash\";|" "$aerion_creds_file"
done

# Update main package (handles version, source hash, npmDepsHash, vendorHash)
cd "$nixpkgs"
nix-update --version="$version" --subpackage frontend aerion

echo "Done!"
