#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p curl gnused jq nix nix-prefetch-git python3 yq-go

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"

latestVersion=$(curl --fail --silent https://api.github.com/repos/edde746/plezy/releases/latest | jq --raw-output .tag_name)

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; plezy.version" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
  echo "plezy is up-to-date: $currentVersion"
  exit 0
fi

echo "updating plezy: $currentVersion -> $latestVersion"

sed -i "s/version = \".*\"/version = \"${latestVersion}\"/" "$ROOT/package.nix"

GIT_SRC_URL="https://github.com/edde746/plezy/archive/refs/tags/${latestVersion}.tar.gz"
GIT_SRC_SHA=$(nix --extra-experimental-features nix-command hash to-sri --type sha256 "$(nix-prefetch-url --unpack "$GIT_SRC_URL")")
sed -i "/fetchFromGitHub/,/hash/{s|hash = \".*\"|hash = \"${GIT_SRC_SHA}\"|}" "$ROOT/package.nix"

DMG_URL="https://github.com/edde746/plezy/releases/download/${latestVersion}/plezy-macos.dmg"
DMG_SHA=$(nix --extra-experimental-features nix-command hash to-sri --type sha256 "$(nix-prefetch-url "$DMG_URL")")
sed -i "/plezy-macos.dmg/,/hash/{s|hash = \".*\"|hash = \"${DMG_SHA}\"|}" "$ROOT/package.nix"

curl --fail --silent "https://raw.githubusercontent.com/edde746/plezy/${latestVersion}/pubspec.lock" \
  | yq eval --output-format=json --prettyPrint > "$ROOT/pubspec.lock.json"

python3 "$(dirname "$(readlink -f "$0")")/../../../development/compilers/dart/fetch-git-hashes.py" \
  --input "$ROOT/pubspec.lock.json" \
  --output "$ROOT/git-hashes.json"
