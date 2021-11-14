#!nix-shell
#!nix-shell -i bash -p coreutils gnugrep git cargo
# shellcheck shell=bash

# This updates cargo-lock.patch for the netease-music-tui version listed in
# default.nix.

set -eu -o verbose

here=$PWD
version=$(cat default.nix | grep '^  version = "' | cut -d '"' -f 2)
checkout=$(mktemp -d)
git clone -b "$version" --depth=1 https://github.com/betta-cyber/netease-music-tui "$checkout"
cd "$checkout"

cargo generate-lockfile
git add -f Cargo.lock
git diff HEAD -- Cargo.lock > "$here"/cargo-lock.patch

cd "$here"
rm -rf "$checkout"
