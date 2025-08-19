#!/usr/bin/env nix-shell
#!nix-shell -i bash -p common-updater-scripts coreutils gnused nix-update

version=$(list-git-tags --url=https://g.blicky.net/ncdu.git | tail -1 | sed 's/^v//')
nix-update --version="$version" ncdu
