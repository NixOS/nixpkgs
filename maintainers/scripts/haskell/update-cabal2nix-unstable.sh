#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils curl jq gnused haskellPackages.cabal2nix-unstable -I nixpkgs=.

# Updates cabal2nix-unstable to the latest master of the nixos/cabal2nix repository.
# See regenerate-hackage-packages.sh for details on the purpose of this script.

set -euo pipefail

# fetch current master HEAD from Github
head_info="$(curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/NixOS/cabal2nix/branches/master)"
# extract commit hash
commit="$(jq -r .commit.sha <<< "$head_info")"
# extract commit timestamp and convert to date
date="$(date "--date=$(jq -r .commit.commit.committer.date <<< "$head_info")" +%F)"
# generate nix expression from cabal file, replacing the version with the commit date
echo '# This file defines cabal2nix-unstable, used by maintainers/scripts/haskell/regenerate-hackage-packages.sh.' > pkgs/development/haskell-modules/cabal2nix-unstable.nix
cabal2nix --subpath cabal2nix "https://github.com/NixOS/cabal2nix/archive/$commit.tar.gz" | sed -e 's/version = ".*"/version = "'"unstable-$date"'"/' >> pkgs/development/haskell-modules/cabal2nix-unstable.nix
