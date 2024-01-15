#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils gnugrep git cargo

# This updates cargo-lock.patch for the netease-music-tui version listed in
# default.nix.

set -euo pipefail

here=$(dirname "$0")
version=$(grep '^  version = "' "$here/default.nix" | cut -d '"' -f 2)
checkout=$(mktemp -d)
git clone -b "v$version" --depth=1 https://github.com/betta-cyber/netease-music-tui "$checkout"

cargo generate-lockfile --manifest-path "$checkout/Cargo.toml"
cp "$checkout/Cargo.lock" "$here"

rm -rf "$checkout"
