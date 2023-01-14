#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=. -i bash -p "callPackage ./maintainers/scripts/format-maintainer-list { }"

format-maintainer-list ./maintainers/maintainer-list.nix > ./maintainers/maintainer-list.nix.tmp
mv ./maintainers/maintainer-list.nix.tmp ./maintainers/maintainer-list.nix
