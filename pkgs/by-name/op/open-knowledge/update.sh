#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nodejs_24 nix-update

set -euo pipefail

version=$(npm view @inkeep/open-knowledge version)

cd "$(dirname "${BASH_SOURCE[0]}")"
npm view @inkeep/open-knowledge@"$version" --json > package.json
npm pkg delete devDependencies
npm install \
  --package-lock-only \
  --ignore-scripts \
  --no-audit \
  --no-fund \
  --omit=dev
rm package.json

cd -
nix-update open-knowledge --version "$version"
