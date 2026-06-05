#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq nix coreutils

set -euo pipefail

MANIFEST_URL="https://desktop-release.q.us-east-1.amazonaws.com/latest/manifest.json"
PACKAGE_DIR="$(dirname "$0")"
PACKAGE_NIX="$PACKAGE_DIR/package.nix"

manifest=$(curl -fsSL "$MANIFEST_URL")
latest_version=$(echo "$manifest" | jq -r '.version')
current_version=$(grep -Po '^\s+version\s*=\s*"\K[0-9.]+' "$PACKAGE_NIX" | head -1)

if [[ "$latest_version" == "$current_version" ]]; then
    echo "kiro-cli is already up to date at version $current_version"
    exit 0
fi

echo "Updating kiro-cli from $current_version to $latest_version"

get_linux_hash() {
    local arch="$1"
    echo "$manifest" | jq -r --arg arch "$arch" '
        .packages[] |
        select(.os == "linux" and .fileType == "tarGz" and .variant == "headless" and .architecture == $arch and (.targetTriple | contains("musl") | not)) |
        .sha256
    '
}

get_darwin_hash() {
    echo "$manifest" | jq -r '
        .packages[] |
        select(.os == "macos" and .fileType == "dmg") |
        .sha256
    '
}

hex_to_sri() {
    local hex="$1"
    nix hash convert --to sri --hash-algo sha256 "$hex"
}

x86_64_linux_hex=$(get_linux_hash "x86_64")
aarch64_linux_hex=$(get_linux_hash "aarch64")
darwin_hex=$(get_darwin_hash)

if [[ -z "$x86_64_linux_hex" || -z "$aarch64_linux_hex" || -z "$darwin_hex" ]]; then
    echo "Error: Could not find all hashes in manifest"
    echo "  x86_64-linux: $x86_64_linux_hex"
    echo "  aarch64-linux: $aarch64_linux_hex"
    echo "  darwin: $darwin_hex"
    exit 1
fi

x86_64_linux_hash=$(hex_to_sri "$x86_64_linux_hex")
aarch64_linux_hash=$(hex_to_sri "$aarch64_linux_hex")
darwin_hash=$(hex_to_sri "$darwin_hex")

echo "x86_64-linux hash: $x86_64_linux_hash"
echo "aarch64-linux hash: $aarch64_linux_hash"
echo "darwin hash: $darwin_hash"

# Get current hashes from package.nix
current_x86_hash=$(grep -A2 'x86_64-linux = fetchurl' "$PACKAGE_NIX" | grep -Po 'hash = "\K[^"]+')
current_aarch64_hash=$(grep -A2 'aarch64-linux = fetchurl' "$PACKAGE_NIX" | grep -Po 'hash = "\K[^"]+')
current_darwin_hash=$(grep -A2 'darwinDmg = fetchurl' "$PACKAGE_NIX" | grep -Po 'hash = "\K[^"]+')

# Update version and hashes
sed -i "s|version = \"$current_version\"|version = \"$latest_version\"|" "$PACKAGE_NIX"
sed -i "s|$current_x86_hash|$x86_64_linux_hash|" "$PACKAGE_NIX"
sed -i "s|$current_aarch64_hash|$aarch64_linux_hash|" "$PACKAGE_NIX"
sed -i "s|$current_darwin_hash|$darwin_hash|" "$PACKAGE_NIX"

echo "Updated kiro-cli to version $latest_version"
