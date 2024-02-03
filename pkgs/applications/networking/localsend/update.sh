#! /usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p curl gnused

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"

latestVersion=$(curl --fail --silent https://api.github.com/repos/localsend/localsend/releases/latest | jq --raw-output .tag_name | sed 's/^v//')

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; localsend.version or (lib.getVersion localsend)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "package is up-to-date: $currentVersion"
  exit 0
fi

sed -i "s/version = \".*\"/version = \"${latestVersion}\"/" "$ROOT/default.nix"

LINUX_x64_URL="https://github.com/localsend/localsend/releases/download/v${latestVersion}/LocalSend-${latestVersion}-linux-x86-64.AppImage"
LINUX_X64_SHA=$(nix hash to-sri --type sha256 $(nix-prefetch-url ${LINUX_x64_URL}))
sed -i "0,/x86_64-linux/{s|x86_64-linux = \".*\"|x86_64-linux = \"${LINUX_X64_SHA}\"|}" "$ROOT/default.nix"

DARWIN_x64_URL="https://github.com/localsend/localsend/releases/download/v${latestVersion}/LocalSend-${latestVersion}.dmg"
DARWIN_X64_SHA=$(nix hash to-sri --type sha256 $(nix-prefetch-url ${DARWIN_x64_URL}))
sed -i "0,/x86_64-darwin/{s|x86_64-darwin = \".*\"|x86_64-darwin = \"${DARWIN_X64_SHA}\"|}" "$ROOT/default.nix"
