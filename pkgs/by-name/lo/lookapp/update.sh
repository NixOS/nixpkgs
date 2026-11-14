#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update common-updater-scripts nix jq

set -euo pipefail

# Linux: version, source hash and cargoHash.
nix-update lookapp

# Darwin ships as a signed zip. That fetchurl derivation cannot be built from
# a Linux updater, so hash the file directly.
version=$(nix-instantiate --eval --strict -E 'with import ./. {}; lookapp.version' | tr -d '"')
url=$(nix-instantiate --eval --strict --system aarch64-darwin -E 'with import ./. {}; lookapp.src.url' | tr -d '"')
hash=$(nix store prefetch-file --json "$url" | jq -r .hash)
update-source-version lookapp "$version" "$hash" --system=aarch64-darwin --ignore-same-version
