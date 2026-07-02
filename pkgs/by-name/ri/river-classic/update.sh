#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash common-updater-scripts gnused zon2nix

latest_tag=$(list-git-tags --url=https://codeberg.org/river/river-classic | sed 's/^v//' | sort --version-sort | tail --lines=1)

update-source-version river-classic "$latest_tag"

wget "https://codeberg.org/river/river-classic/raw/tag/v${latest_tag}/build.zig.zon"
zon2nix build.zig.zon >pkgs/by-name/ri/river-classic/build.zig.zon.nix
nixfmt pkgs/by-name/ri/river-classic/build.zig.zon.nix

rm -f build.zig.zon build.zig.zon.nix
