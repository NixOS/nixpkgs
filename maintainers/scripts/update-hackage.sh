#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix curl jq nix-prefetch-github -I nixpkgs=.

# See regenerate-hackage-packages.sh for details on the purpose of this script.

set -euo pipefail

current_commit="$(nix-instantiate --eval . -A all-cabal-hashes.commit)"
head_commit="$(curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/commercialhaskell/all-cabal-hashes/branches/hackage | jq -r .commit.sha)"
if [ "$current_commit" != "$head_commit" ]; then
    nix-prefetch-github commercialhaskell all-cabal-hashes --rev "$head_commit" > pkgs/data/misc/hackage/pin.json
fi
