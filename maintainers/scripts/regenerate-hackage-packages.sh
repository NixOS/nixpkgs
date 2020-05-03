#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils haskellPackages.cabal2nix-latest -I nixpkgs=.

# This script is used to regenerate nixpkgs' Haskell package set, using a tool
# called hackage2nix. hackage2nix looks at
# pkgs/development/haskell-modules/configuration-hackage2nix.yaml and generates
# a Nix expression for package version specified there, using the Cabal files
# from the Hackage database (available under all-cabal-hashes) and its
# companion tool cabal2nix.
#
# Related scripts are update-hackage.sh, for updating the snapshot of the
# Hackage database used by hackage2nix, and update-cabal2nix-latest.sh,
# for updating the version of hackage2nix used to perform this task.

set -euo pipefail

# fetch and unpack hackage hashes
unpacked_hackage="$(nix-build . -A all-cabal-hashes --no-out-link)"
# run hackage2nix, the one from the argument if given
eval ${1:-hackage2nix} --hackage "$unpacked_hackage" --preferred-versions <(for n in "$unpacked_hackage"/*/preferred-versions; do cat "$n"; echo; done) --nixpkgs "$PWD" --config pkgs/development/haskell-modules/configuration-hackage2nix.yaml
