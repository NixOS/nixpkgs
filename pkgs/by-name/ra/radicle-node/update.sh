#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils gnugrep common-updater-scripts nix-update

version=$(list-git-tags | grep -oP '^releases/\K\d+\.\d+\.\d+$' | sort -rV | head -1)
nix-update --version="$version" radicle-node
