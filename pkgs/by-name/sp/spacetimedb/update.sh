#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update curl yq

set -euo pipefail

# Update spacetimedb
old_version="$(nix-instantiate --raw --eval -A spacetimedb.version)"
nix-update spacetimedb
new_version="$(nix-instantiate --raw --eval -A spacetimedb.version)"

if [ "$old_version" = "$new_version" ]; then
  echo "No spacetimedb update, nothing to do"
  exit 0
fi

# Extract v8 version from spacetimedb's Cargo.lock
new_v8_version="$(curl -sL "https://raw.githubusercontent.com/clockworklabs/SpacetimeDB/refs/tags/v$new_version/Cargo.lock" | \
  tomlq -r '.package[] | select(.name == "v8") | .version')"

echo "Updating librusty_v8 to $new_v8_version"

# Update librusty_v8 via nix-update on the passthru
nix-update spacetimedb.librusty_v8 "--version=$new_v8_version" --override-filename pkgs/by-name/sp/spacetimedb/package.nix

echo "Updated spacetimedb to $new_version with rusty-v8 $new_v8_version"
