#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash wget common-updater-scripts gnused

latest_tag=$(list-git-tags --url=https://github.com/neurocyte/flow | sed 's/^v//' | tail -n 1)

update-source-version flow-control "$latest_tag"

mkdir -p src/syntax

wget "https://raw.githubusercontent.com/neurocyte/flow/v${latest_tag}/build.zig.zon"
wget -P src/syntax "https://raw.githubusercontent.com/neurocyte/flow/v${latest_tag}/src/syntax/build.zig.zon"

nix --extra-experimental-features 'nix-command flakes' run github:Cloudef/zig2nix#zon2nix -- build.zig.zon
mv build.zig.zon.nix pkgs/by-name/fl/flow-control/build.zig.zon.nix

# strip file protocol
sed -i '\|file = unpackZigArtifact { inherit name; artifact = /. + path; };|d' pkgs/by-name/fl/flow-control/build.zig.zon.nix
nixfmt pkgs/by-name/fl/flow-control/build.zig.zon.nix

rm -rf build.zig.zon build.zig.zon2json-lock src/
