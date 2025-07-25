#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash jq zon2nix

commit=$(nix-instantiate --eval -A river-bedload.src.rev | jq --raw-output)

wget "https://git.sr.ht/~novakane/river-bedload/blob/${commit}/build.zig.zon"
zon2nix build.zig.zon >pkgs/by-name/ri/river-bedload/build.zig.zon.nix
nixfmt pkgs/by-name/ri/river-bedload/build.zig.zon.nix

rm -f build.zig.zon
