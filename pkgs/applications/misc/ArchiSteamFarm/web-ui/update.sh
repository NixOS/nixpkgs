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
curl "https://raw.githubusercontent.com/JustArchiNET/ASF-ui/$ui/package.json" -o package.json

# update-source-version doesn't work for some reason
sed -i "s/rev\\s*=\\s*.*/rev = \"$ui\";/" default.nix
sed -i "s/sha256\\s*=\\s*.*/sha256 = \"$(nix-prefetch-url --unpack "https://github.com/JustArchiNET/ASF-ui/archive/$ui.tar.gz")\";/" default.nix

node2nix \
  --nodejs-14 \
  --development \
  --lock package-lock.json \
  --node-env ../../../../development/node-packages/node-env.nix \
  --output node-packages.nix \
  --composition node-composition.nix \

rm package.json package-lock.json

popd
