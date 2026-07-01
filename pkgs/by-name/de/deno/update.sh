#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update curl yq

set -euo pipefail

# Update deno
old_version="$(nix-instantiate --raw --eval -A deno.version)"
nix-update deno
new_version="$(nix-instantiate --raw --eval -A deno.version)"

if [ "$old_version" = "$new_version" ]; then
  echo "No deno update, nothing to do"
  exit 0
fi

# Extract v8 version from deno's Cargo.lock
new_v8_version="$(curl -sL "https://raw.githubusercontent.com/denoland/deno/refs/tags/v$new_version/Cargo.lock" | \
  tomlq -r '.package[] | select(.name == "v8") | .version')"

echo "Updating librusty_v8 to $new_v8_version"

# Update librusty_v8 via nix-update on the passthru
nix-update deno.librusty_v8 "--version=$new_v8_version" --override-filename pkgs/by-name/de/deno/package.nix

echo "Updated deno to $new_version with rusty-v8 $new_v8_version"
