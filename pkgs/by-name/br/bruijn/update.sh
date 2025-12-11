#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils cabal2nix curl jq

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

{ read -r rev; read -r committer_date; } \
  < <(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sfL https://api.github.com/repos/marvinborner/bruijn/branches/main \
    | jq -r '.commit | .sha, .commit.committer.date')

cabal2nix --maintainer defelo "https://github.com/marvinborner/bruijn/archive/${rev}.tar.gz" \
  | nixfmt \
  > generated.nix

echo "0-unstable-$(date -I --date="$committer_date")" > version.txt
