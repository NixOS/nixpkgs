#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl jq yq nix bash coreutils common-updater-scripts

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"

latestTag=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/orz12/PiliPalaX/releases/latest | jq --raw-output .tag_name)
latestVersion=$(echo "$latestTag" | awk -F'+' '{print $1}')
RunNumber=$(echo "$latestTag" | grep -o '[^+]*$')

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; pilipalax.version or (lib.getVersion pilipalax)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

sed -i "s/\(tag = \"\${version}+\)[0-9]\+/\1${RunNumber}/" "$ROOT/package.nix"

hash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri $(nix-prefetch-url --unpack "https://github.com/orz12/PiliPalaX/archive/refs/tags/${latestTag}.tar.gz"))
update-source-version pilipalax $latestVersion $hash

curl https://raw.githubusercontent.com/orz12/PiliPalaX/${latestTag}/pubspec.lock | yq . >$ROOT/pubspec.lock.json
