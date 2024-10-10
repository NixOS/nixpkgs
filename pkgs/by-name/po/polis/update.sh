#!/usr/bin/env bash

set -euo pipefail

nixpkgs=$(git rev-parse --show-toplevel)
targetDir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/generated

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' exit

rev=$(git ls-remote https://github.com/compdemocracy/polis refs/heads/edge | cut -f1)

date=$(curl -sSL \
  -H "Accept: application/vnd.github+json" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/repos/compdemocracy/polis/commits/"$rev" |
  jq -r '.commit.committer.date | fromdateiso8601 | strftime("%Y-%m-%d")')
echo "Revision: $rev, date: $date"

readarray -t fetched < <(nix-prefetch-url --unpack --name source --print-path https://github.com/compdemocracy/polis/archive/"$rev".tar.gz)
hash=''${fetched[0]}
storePath=''${fetched[1]}
echo "Hash: $hash, storePath: $storePath"

cp --no-preserve=mode "$storePath"/client-participation/package.json "$tmp"
npm=$(nix-build "$nixpkgs" -A nodejs)
(cd "$tmp" && "$npm"/bin/npm install --package-lock-only)
cp "$tmp"/package-lock.json "$targetDir"/client-participation-package-lock.json

jq -n \
    --arg rev "$rev" \
    --arg sha256 "$hash" \
    --arg date "$date" \
    '$ARGS.named' > "$targetDir"/source.json

nix-build "$nixpkgs" -A polis._updateScriptUtils.clojure-nix-locker-patched
cp --no-preserve=mode result/{createHome,utils}.nix "$targetDir"

nix-build "$nixpkgs" -A polis._updateScriptUtils.commandLocker
result/bin/clojure-nix-locker

echo "Successfully updated everything except npmDepsHash values"
