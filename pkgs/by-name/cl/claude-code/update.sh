#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nodejs nix-update

set -euo pipefail

# Get the package directory (absolute path)
PACKAGE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get latest version from npm registry
echo "Fetching latest version from npm registry..."
version=$(npm view @anthropic-ai/claude-code version)

if [ -z "$version" ]; then
    echo "Error: Could not retrieve version from npm registry"
    exit 1
fi

echo "Latest version: $version"

# Generate updated lock file
echo "Generating package-lock.json for version $version..."
cd "$PACKAGE_DIR"

# Create a temporary package.json for dependency resolution
npm i --package-lock-only @anthropic-ai/claude-code@"$version"

# Clean up the temporary package.json
rm -f package.json

echo "Successfully generated package-lock.json"

# Update version and hashes using nix-update
echo "Updating package definition with nix-update..."

# nix-update needs to be run from nixpkgs root
NIXPKGS_ROOT="$PACKAGE_DIR"
while [ ! -f "$NIXPKGS_ROOT/default.nix" ] && [ "$NIXPKGS_ROOT" != "/" ]; do
    NIXPKGS_ROOT="$(dirname "$NIXPKGS_ROOT")"
done

if [ ! -f "$NIXPKGS_ROOT/default.nix" ]; then
    echo "Error: Could not find nixpkgs root directory"
    exit 1
fi

cd "$NIXPKGS_ROOT"
nix-update claude-code --version "$version"

echo "Update completed successfully!"
