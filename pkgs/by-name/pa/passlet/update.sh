#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts nix-update

set -euo pipefail

# Upstream also pushes vX.Y.Z-prepare tags, which are not releases.
nix-update passlet --system x86_64-linux --version-regex '^v(\d+\.\d+\.\d+)$'

version=$(nix-instantiate --eval --raw -A passlet.version)
url=$(nix-instantiate --eval --raw --system aarch64-darwin -A passlet.src.url)
hash=$(nix-hash --to-sri --type sha256 "$(nix-prefetch-url "$url")")
update-source-version passlet "$version" "$hash" \
  --system=aarch64-darwin --ignore-same-version --ignore-same-hash
