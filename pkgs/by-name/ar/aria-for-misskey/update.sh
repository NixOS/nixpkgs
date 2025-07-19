#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl gnused jq yq-go nix bash coreutils common-updater-scripts

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"

latestTag=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/poppingmoon/aria/releases/latest | jq --raw-output .tag_name)
latestVersion=$(echo "$latestTag" | sed 's/^v//' | grep -o '^[^+]*')
RunNumber=$(echo "$latestTag" | grep -o '[^+]*$')

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; aria-for-misskey.version or (lib.getVersion aria-for-misskey)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

sed -i "s/\(tag = \"v\${version}+\)[0-9]\+/\1${RunNumber}/" "$ROOT/package.nix"

hash=$(nix hash convert --hash-algo sha256 --to sri $(nix-prefetch-url --unpack "https://github.com/poppingmoon/aria/archive/refs/tags/${latestTag}.tar.gz"))
update-source-version aria-for-misskey $latestVersion $hash

curl https://raw.githubusercontent.com/poppingmoon/aria-for-misskey/${latestTag}/pubspec.lock | yq . -o=json >$ROOT/pubspec.lock.json
