#!/usr/bin/env nix-shell
#!nix-shell -i bash -p jq

set -euo pipefail

SCRIPT_DIRECTORY=$(cd "$(dirname "${BASH_SOURCE[0]}")"; cd -P "$(dirname "$(readlink "${BASH_SOURCE[0]}" || echo .)")"; pwd)

repo=https://github.com/nixos/nixpkgs
branch=nixpkgs-unstable
file=${SCRIPT_DIRECTORY}/pinned-nixpkgs.json

defaultRev=$(git ls-remote "$repo" refs/heads/"$branch" | cut -f1)
rev=${1:-$defaultRev}
sha256=$(nix-prefetch-url --unpack "$repo/archive/$rev.tar.gz" --name source)

jq -n --arg rev "$rev" --arg sha256 "$sha256" '$ARGS.named' | tee /dev/stderr > $file
