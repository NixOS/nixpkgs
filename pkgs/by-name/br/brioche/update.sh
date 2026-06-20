#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update curl yq

set -euo pipefail

# Update brioche
old_version="$(nix-instantiate --raw --eval -A brioche.version)"
nix-update brioche
new_version="$(nix-instantiate --raw --eval -A brioche.version)"

if [ "$old_version" = "$new_version" ]; then
  echo "No brioche update, nothing to do"
  exit 0
fi

# Extract v8 version from brioche's Cargo.lock
new_v8_version="$(curl -sL "https://raw.githubusercontent.com/brioche-dev/brioche/refs/tags/v$new_version/Cargo.lock" | \
  tomlq -r '.package[] | select(.name == "v8") | .version')"

echo "Updating librusty_v8 to $new_v8_version"

# Update librusty_v8 via nix-update on the passthru
nix-update brioche.librusty_v8 "--version=$new_v8_version" --override-filename pkgs/by-name/br/brioche/package.nix

echo "Updated brioche to $new_version with rusty-v8 $new_v8_version"
