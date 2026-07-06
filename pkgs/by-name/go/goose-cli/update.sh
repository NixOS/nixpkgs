#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-update curl yq

set -euo pipefail

# Update goose-cli
old_version="$(nix-instantiate --raw --eval -A goose-cli.version)"
nix-update goose-cli
new_version="$(nix-instantiate --raw --eval -A goose-cli.version)"

if [ "$old_version" = "$new_version" ]; then
  echo "No goose-cli update, nothing to do"
  exit 0
fi

# Extract v8 version from goose's Cargo.lock
new_v8_version="$(curl -sL "https://raw.githubusercontent.com/block/goose/refs/tags/v$new_version/Cargo.lock" | \
  tomlq -r '.package[] | select(.name == "v8") | .version')"

new_v8_major="$(echo "$new_v8_version" | cut -d. -f1)"
echo "Updating librusty_v8 to $new_v8_version (rusty-v8_$new_v8_major)"

"$(dirname "${BASH_SOURCE[0]}")/../../../../pkgs/build-support/build-rusty-v8/create-new-version.sh" --major "$new_v8_major" --version "$new_v8_version"

# Update rusty-v8 import in package.nix
sed -i "s/rusty-v8_[0-9]\+/rusty-v8_$new_v8_major/g" "$(dirname "${BASH_SOURCE[0]}")/package.nix"

echo "Updated goose-cli to $new_version with rusty-v8 $new_v8_version"
