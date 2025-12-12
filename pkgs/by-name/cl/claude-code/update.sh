#!/usr/bin/env nix
#!nix shell --ignore-environment .#cacert .#nodejs .#git .#nix-update .#nix .#gnused .#findutils .#bash --command bash

set -euo pipefail

version=$(npm view @anthropic-ai/claude-code version)

# Update version and hashes
AUTHORIZED=1 NIXPKGS_ALLOW_UNFREE=1 nix-update claude-code --version="$version" --generate-lockfile

# nix-update can't update package-lock.json along with npmDepsHash
# TODO: Remove this workaround if nix-update can update package-lock.json along with npmDepsHash.
(nix-build --expr '((import ./.) { system = builtins.currentSystem; }).claude-code.npmDeps.overrideAttrs { outputHash = ""; outputHashAlgo = "sha256"; }' 2>&1 || true) \
| sed -nE '$s/ *got: *(sha256-[A-Za-z0-9+/=-]+).*/\1/p' \
| xargs -I{} sed -i 's|npmDepsHash = "sha256-[^"]*";|npmDepsHash = "{}";|' pkgs/by-name/cl/claude-code/package.nix
