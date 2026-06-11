#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bash curl jq

set -eu -o pipefail

url='https://data.nexusmods.com/file/nexus-data/games.json'
self=$(realpath "$0")
dir=$(dirname "$self")
tmp=$(mktemp)

cd "$dir"/../../../../../

ids=$(
  nix-instantiate --eval --json \
    --argstr file "$dir"/game-ids.nix \
    --expr '{file}: builtins.attrValues (import file)'
)

echo "Fetching games data" >&2
curl "$url" \
  --silent \
  --show-error \
  --location |
  jq --argjson ids "$ids" \
    'map(select( .id | IN($ids[]) )) | sort_by(.id)' \
    >"$tmp"

echo "Validating result" >&2
nix-instantiate --eval --strict \
  --argstr idsNix "$dir"/game-ids.nix \
  --argstr gamesJson "$tmp" \
  --expr '
    {
      idsNix,
      gamesJson,
      lib ? import <nixpkgs/lib>,
    }:
    let
      ids = import idsNix;
      games = lib.importJSON gamesJson;
    in
    lib.forEach games (
      { id, name, ... }:
      lib.throwIfNot
        (id == ids.${name})
        "${name}: id ${toString id} does not match ${toString ids.${name}}"
        null
    )
  ' \
  >/dev/null

echo "Installing games.json to $dir" >&2
mv --force "$tmp" "$dir"/games.json
