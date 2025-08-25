#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils gnused common-updater-scripts nix-update

version=$(list-git-tags | tail -1 | sed 's|^releases/||')
nix-update --version="$version" radicle-node
