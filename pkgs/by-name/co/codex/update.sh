#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update curl yq

set -euo pipefail

# Update codex
old_version="$(nix-instantiate --raw --eval -A codex.version)"
nix-update codex
new_version="$(nix-instantiate --raw --eval -A codex.version)"

if [ "$old_version" = "$new_version" ]; then
  echo "No codex update, nothing to do"
  exit 0
fi

# Extract v8 version from codex's Cargo.lock
# codex uses rust-v prefix for tags
new_v8_version="$(curl -sL "https://raw.githubusercontent.com/openai/codex/refs/tags/rust-v$new_version/Cargo.lock" | \
  tomlq -r '.package[] | select(.name == "v8") | .version')"

echo "Updating librusty_v8 to $new_v8_version"

# Update librusty_v8 via nix-update on the passthru
nix-update codex.librusty_v8 "--version=$new_v8_version" --override-filename pkgs/by-name/co/codex/package.nix

echo "Updated codex to $new_version with rusty-v8 $new_v8_version"
