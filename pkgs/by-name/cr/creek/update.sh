#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts gnused

latest_tag=$(list-git-tags --url=https://github.com/nmeum/creek | sed 's/^v//' | tail -n 1)

update-source-version creek "$latest_tag"

wget "https://raw.githubusercontent.com/nmeum/creek/v${latest_tag}/build.zig.zon"
nix --extra-experimental-features 'nix-command flakes' run github:nix-community/zon2nix# -- build.zig.zon >pkgs/by-name/cr/creek/build.zig.zon.nix

nixfmt pkgs/by-name/cr/creek/build.zig.zon.nix

rm -rf build.zig.zon
