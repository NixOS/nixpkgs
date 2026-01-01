#!/usr/bin/env nix-shell
<<<<<<< HEAD
#!nix-shell -i bash -p bash jq zon2nix wget
=======
#!nix-shell -i bash -p bash jq zon2nix
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

commit=$(nix-instantiate --eval -A river-bedload.src.rev | jq --raw-output)

wget "https://git.sr.ht/~novakane/river-bedload/blob/${commit}/build.zig.zon"
zon2nix build.zig.zon >pkgs/by-name/ri/river-bedload/build.zig.zon.nix
nixfmt pkgs/by-name/ri/river-bedload/build.zig.zon.nix

rm -f build.zig.zon
