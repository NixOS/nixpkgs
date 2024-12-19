#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=../../../../.. -i bash -p curl gnused jq common-updater-scripts prefetch-npm-deps
set -eou pipefail

cd "$(dirname "$0")"/../../../../..
version=$(nix-instantiate --strict --eval -A ArchiSteamFarm.version | jq -r)
cd -
ui=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "https://api.github.com/repos/JustArchiNET/ArchiSteamFarm/contents/ASF-ui?ref=$version" | jq -r .sha)

curl "https://raw.githubusercontent.com/JustArchiNET/ASF-ui/$ui/package-lock.json" -o package-lock.json

cd -
update-source-version ArchiSteamFarm.ui "$ui"
cd -

npmDepsHash=$(prefetch-npm-deps ./package-lock.json)
sed -E 's#\bnpmDepsHash = ".*?"#npmDepsHash = "'"$npmDepsHash"'"#' -i default.nix

rm package-lock.json
