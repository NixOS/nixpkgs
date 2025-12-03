#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nodePackages.npm nix-update

set -euo pipefail

version=$(npm view @sourcegraph/amp version)

# Generate updated lock file
cd "$(dirname "${BASH_SOURCE[0]}")"
npm i --package-lock-only @sourcegraph/amp@"$version"
rm -f package.json # package.json is not used by buildNpmPackage

# Update version and hashes
cd -
nix-update amp-cli --version "$version"
