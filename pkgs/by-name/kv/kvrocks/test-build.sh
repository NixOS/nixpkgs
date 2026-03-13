#!/usr/bin/env bash
set -uo pipefail

# Get the directory of the script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

echo "=== Testing kvrocks package build ==="
echo ""
echo "Changing to directory: $DIR"
cd "$DIR"

echo "Building kvrocks package..."
nix-build -E 'with import <nixpkgs> {}; callPackage ./package.nix { pkgsBuild = import <nixpkgs> { system = stdenv.buildPlatform.system; }; }'
