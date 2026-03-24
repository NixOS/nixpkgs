#!/usr/bin/env bash

# OUT=$(nix flake archive --json | grep "^{\"path\":\"/nix/store/[a-z0-9]*-source" -o | grep -o "/nix/store/.*" -o)
# tar cf nixpkgs.tar.xz -C /nix/store "$(basename "$OUT")" --xz

git worktree add clean HEAD
mv clean/.git /tmp -v
tar cf nixpkgs.tar.xz clean --xz
mv /tmp/.git clean -v
git worktree remove clean

