#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nodePackages.npm nix-update

set -euo pipefail

version=$(npm view @anthropic-ai/claude-code version)

# Generate updated lock file
cd "$(dirname "${BASH_SOURCE[0]}")"
npm i --package-lock-only @anthropic-ai/claude-code@"$version"
rm -f package.json

# Update version and hashes
cd -
nix-update claude-code --version "$version"
