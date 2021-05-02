#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix curl jq nix-prefetch-github -I nixpkgs=.

# See regenerate-hackage-packages.sh for details on the purpose of this script.

set -euo pipefail

pin_file=pkgs/data/misc/hackage/pin.json
current_commit="$(jq -r .commit $pin_file)"
head_commit="$(curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/commercialhaskell/all-cabal-hashes/branches/hackage | jq -r .commit.sha)"

if [ "$current_commit" != "$head_commit" ]; then
   url="https://github.com/commercialhaskell/all-cabal-hashes/archive/$head_commit.tar.gz"
   hash="$(nix-prefetch-url "$url")"
   jq -n \
     --arg commit "$head_commit" \
     --arg hash "$hash" \
     --arg url "$url" \
     '{commit: $commit, url: $url, sha256: $hash}' \
     > $pin_file
fi
