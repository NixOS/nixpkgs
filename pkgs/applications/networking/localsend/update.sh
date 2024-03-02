#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p curl gnused jq yq nix-prefetch-url

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"

latestVersion=$(curl --fail --silent https://api.github.com/repos/localsend/localsend/releases/latest | jq --raw-output .tag_name | sed 's/^v//')

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; localsend.version or (lib.getVersion localsend)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "package is up-to-date: $currentVersion"
  exit 0
fi

sed -i "s/version = \".*\"/version = \"${latestVersion}\"/" "$ROOT/default.nix"

DARWIN_x64_URL="https://github.com/localsend/localsend/releases/download/v${latestVersion}/LocalSend-${latestVersion}.dmg"
DARWIN_X64_SHA=$(nix hash to-sri --type sha256 $(nix-prefetch-url ${DARWIN_x64_URL}))
sed -i "/darwin/,/hash/{s|hash = \".*\"|hash = \"${DARWIN_X64_SHA}\"|}" "$ROOT/default.nix"

GIT_SRC_URL="https://github.com/localsend/localsend/archive/refs/tags/v${latestVersion}.tar.gz"
GIT_SRC_SHA=$(nix hash to-sri --type sha256 $(nix-prefetch-url --unpack ${GIT_SRC_URL}))
sed -i "/linux/,/hash/{s|hash = \".*\"|hash = \"${GIT_SRC_SHA}\"|}" "$ROOT/default.nix"
curl https://raw.githubusercontent.com/localsend/localsend/v${latestVersion}/app/pubspec.lock | yq . > $ROOT/pubspec.lock.json
