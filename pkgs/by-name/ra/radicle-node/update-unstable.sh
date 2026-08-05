#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils gnugrep gnused common-updater-scripts nix-update

version=$(list-git-tags | grep -oP '^releases/\K\d+\.\d+\.\d+.*' \
  | sed -E 's/-(alpha|beta|rc)\./~\1./' | sort -rV | tr '~' - | head -1)
nix-update --version="$version" radicle-node-unstable --override-filename pkgs/by-name/ra/radicle-node/unstable.nix
