#!/usr/bin/env nix-shell
#!nix-shell -i nu -p nushell common-updater-scripts zon2nix

let latest_tag = list-git-tags --url=https://codeberg.org/river/river | lines | sort --natural | str replace v '' | last
update-source-version river $latest_tag

http get $"https://codeberg.org/river/river/raw/tag/v($latest_tag)/build.zig.zon" | save build.zig.zon
zon2nix > pkgs/by-name/ri/river/build.zig.zon.nix
