#!/usr/bin/env nix-shell
#!nix-shell -i bash --keep GITHUB_TOKEN -p curl jq nix yq-go flutter nix-update

set -euo pipefail

PACKAGE_DIR=$(realpath "$(dirname "$0")")

latestVersion=$(
  curl -s ${GITHUB_TOKEN:+ -H "Authorization: Bearer $GITHUB_TOKEN"} https://api.github.com/repos/Chevey339/kelivo/releases/latest |
    jq -r .tag_name |
    sed 's/^v//'
)
currentVersion=$(nix eval --raw --file . kelivo.version)

[[ $currentVersion == $latestVersion ]] && {
  echo "package is up-to-date: $currentVersion"
  exit 0
}

nix-update --version=$latestVersion kelivo

src=$(nix build --no-link --print-out-paths .#kelivo.src)
source=$(mktemp -d)
cp -r --no-preserve=mode "$src/"* "$source"
pushd "$source"
flutter pub get
yq pubspec.lock --output-format=json >"$PACKAGE_DIR/pubspec.lock.json"
popd
rm -rf "$source"
