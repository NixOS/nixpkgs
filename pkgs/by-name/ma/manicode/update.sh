#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nodePackages.npm nix-update

set -euo pipefail

version=$(npm view manicode version)

# Generate updated lock file
cd "$(dirname "${BASH_SOURCE[0]}")"
npm i --package-lock-only manicode@$version
rm -f package.json

# Update version and hases
cd -
nix-update manicode --version "$version"
