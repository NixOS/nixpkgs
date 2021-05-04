#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils haskellPackages.cabal2nix-unstable -I nixpkgs=.

# This script is used to regenerate nixpkgs' Haskell package set, using a tool
# called hackage2nix. hackage2nix looks at
# pkgs/development/haskell-modules/configuration-hackage2nix.yaml and generates
# a Nix expression for package version specified there, using the Cabal files
# from the Hackage database (available under all-cabal-hashes) and its
# companion tool cabal2nix.
#
# Related scripts are update-hackage.sh, for updating the snapshot of the
# Hackage database used by hackage2nix, and update-cabal2nix-unstable.sh,
# for updating the version of hackage2nix used to perform this task.

set -euo pipefail

extractionDerivation='with import ./. {}; runCommand "unpacked-cabal-hashes" { } "tar xf ${all-cabal-hashes} --strip-components=1 --one-top-level=$out"'
unpacked_hackage="$(nix-build -E "$extractionDerivation" --no-out-link)"

hackage2nix --hackage "$unpacked_hackage" --preferred-versions <(for n in "$unpacked_hackage"/*/preferred-versions; do cat "$n"; echo; done) --nixpkgs "$PWD" --config pkgs/development/haskell-modules/configuration-hackage2nix.yaml

if [[ "${1:-}" == "--do-commit" ]]; then
   git add pkgs/development/haskell-modules/hackage-packages.nix
   git commit -m "hackage-packages.nix: Regenerate based on current config"
fi
