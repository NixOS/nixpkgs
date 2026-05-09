#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash nix-update
set -e
nix-update kak-tree-sitter-unwrapped --version-regex 'kak-tree-sitter-v(.*)'
./pkgs/by-name/ka/kak-tree-sitter/update-parsers.sh
