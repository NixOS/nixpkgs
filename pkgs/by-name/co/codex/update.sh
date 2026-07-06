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
# codex uses rust-v prefix for tags and Cargo.lock is in codex-rs/
new_v8_version="$(curl -sL "https://raw.githubusercontent.com/openai/codex/refs/tags/rust-v$new_version/codex-rs/Cargo.lock" | \
  tomlq -r '.package[] | select(.name == "v8") | .version')"

new_v8_major="$(echo "$new_v8_version" | cut -d. -f1)"
echo "Updating librusty_v8 to $new_v8_version (rusty-v8_$new_v8_major)"

"$(dirname "${BASH_SOURCE[0]}")/../../../../pkgs/build-support/build-rusty-v8/create-new-version.sh" --major "$new_v8_major" --version "$new_v8_version"

# Update rusty-v8 import in package.nix
sed -i "s/rusty-v8_[0-9]\+/rusty-v8_$new_v8_major/g" "$(dirname "${BASH_SOURCE[0]}")/package.nix"

echo "Updated codex to $new_version with rusty-v8 $new_v8_version"
