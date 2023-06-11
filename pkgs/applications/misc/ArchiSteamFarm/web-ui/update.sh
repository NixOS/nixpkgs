#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=../../../.. -i bash -p nodePackages.node2nix gnused jq curl
set -eou pipefail

cd "$(dirname "$0")"
pushd ../../../../..
version=$(nix-instantiate --strict --eval -A ArchiSteamFarm.version | jq -r)
popd
pushd "$(dirname "$0")"
ui=$(curl ${GITHUB_TOKEN:+" -u \":$GITHUB_TOKEN\""} "https://api.github.com/repos/JustArchiNET/ArchiSteamFarm/contents/ASF-ui?ref=$version" | jq -r .sha)

curl "https://raw.githubusercontent.com/JustArchiNET/ASF-ui/$ui/package-lock.json" -o package-lock.json

# update-source-version doesn't work for some reason
sed -i "s/rev\\s*=\\s*.*/rev = \"$ui\";/" default.nix
sed -i "s/hash\\s*=\\s*.*/hash = \"$(nix-prefetch fetchurl --url "https://github.com/JustArchiNET/ASF-ui/archive/$ui.tar.gz")\";/" default.nix

npmDepsHash=$(prefetch-npm-deps ./package-lock.json)
sed -E 's#\bnpmDepsHash = ".*?"#npmDepsHash = "'"$npmDepsHash"'"#' -i default.nix

rm package-lock.json

popd
