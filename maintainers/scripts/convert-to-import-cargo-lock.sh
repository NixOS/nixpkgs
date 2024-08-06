#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=. -i bash -p "import maintainers/scripts/convert-to-import-cargo-lock { }"
# The tool must be ran from the root directory of 'nixpkgs' repository.
exec convert-to-import-cargo-lock "$@"
