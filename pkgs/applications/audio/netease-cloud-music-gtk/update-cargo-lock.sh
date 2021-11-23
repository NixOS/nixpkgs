#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils ripgrep git cargo
# shellcheck shell=bash

# Ref: https://github.com/NixOS/nixpkgs/blob/nixos-21.05/pkgs/applications/audio/netease-music-tui/update-cargo-lock.sh

set -eu -vx

here=$PWD
version=$(cat default.nix | rg '^  version = "' | cut -d '"' -f 2)
checkout=$(mktemp -d)

git clone -b "$version" --depth=1 https://github.com/gmg137/netease-cloud-music-gtk "$checkout"
cd "$checkout"

cargo generate-lockfile
git add -f Cargo.lock
git diff HEAD -- Cargo.lock > "$here"/cargo-lock.patch

cd "$here"
rm -rf "$checkout"
