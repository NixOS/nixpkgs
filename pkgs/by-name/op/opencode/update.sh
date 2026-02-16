#!/usr/bin/env nix-shell
#! nix-shell -i bash --pure -p cacert curl jq nix nix-prefetch-git gnused
# shellcheck shell=bash
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

# Fetch the latest release version from GitHub
latest_version=$(curl -sSL "https://api.github.com/repos/anomalyco/opencode/releases/latest" | jq -r '.tag_name' | sed 's/^v//')

# Get the current version from package.nix
current_version=$(grep -oP '^\s*version = "\K[^"]+' package.nix)

if [ "$latest_version" = "$current_version" ]; then
    echo "Already on latest version: $latest_version"
    exit 0
fi

echo "Updating opencode from $current_version to $latest_version"

# Fetch the new hash for src
echo "Fetching source hash for v$latest_version..."
new_hash=$(nix-prefetch-git --fetch-submodules "https://github.com/anomalyco/opencode" "v$latest_version" | jq -r '.sha256')

# Convert to SRI format
sri_hash=$(nix hash to-sri --type sha256 "$new_hash")

# Update package.nix with new version and src hash
sed -i "s/version = \"[^\"]*\"/version = \"$latest_version\"/" package.nix
sed -i "0,/hash = \"sha256-[^\"]*\"/s|hash = \"sha256-[^\"]*\"|hash = \"$sri_hash\"|" package.nix

echo "Updated source hash to $sri_hash"
echo ""
echo "Computing node_modules hash..."

# Extract the current node_modules hash from the outputHash section
current_nm_hash=$(sed -n '/outputHash =/,/outputHashAlgo/p' package.nix | grep -oP '"sha256-[^"]*"' | head -1 | tr -d '"')

if [ -z "$current_nm_hash" ]; then
    echo "❌ Error: Could not find current node_modules hash in package.nix"
    exit 1
fi

echo "Found current node_modules hash: $current_nm_hash"

# Replace both darwin and linux hashes with placeholder (all zeros) to trigger computation
sed -i "s|$current_nm_hash|sha256-0000000000000000000000000000000000000000000=|g" package.nix

# Try to build node_modules and capture hash from error message
build_output=$(nix build ".#opencode.node_modules" --no-link 2>&1 || true)

# Extract the hash from the "got:" line in the error output (handles extra whitespace)
node_modules_hash=$(echo "$build_output" | grep -oP 'got:\s+\K[^ ]+' | head -1 || true)

if [ -z "$node_modules_hash" ]; then
    echo "❌ Error: Could not compute node_modules hash."
    echo ""
    echo "Build output:"
    echo "$build_output" | tail -20
    echo ""
    echo "You may need to build manually on your platform:"
    echo "  nix build '.#opencode.node_modules' --system x86_64-linux"
    echo "  nix build '.#opencode.node_modules' --system aarch64-darwin"
    exit 1
fi

echo "Computed node_modules hash: $node_modules_hash"

# Update both placeholder hashes with the actual computed hash
sed -i "s|\"sha256-0000000000000000000000000000000000000000000=\"|\"$node_modules_hash\"|g" package.nix

echo ""
echo "✅ Successfully updated:"
echo "   - Version: $latest_version"
echo "   - Source hash: $sri_hash"
echo "   - Node modules hash: $node_modules_hash"
