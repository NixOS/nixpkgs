#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p curl gnused jq yq nix bash coreutils common-updater-scripts

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"

latestTag=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/HemantKArya/BloomeeTunes/releases/latest | jq --raw-output .tag_name)
latestVersion=$(echo "$latestTag" | sed 's/^v//' | grep -o '^[^+]*')
RunNumber=$(echo "$latestTag" | grep -o '[^+]*$')

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; bloomeetunes.version or (lib.getVersion bloomeetunes)" | tr -d '"')

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

sed -i "s/\(tag = \"v\${version}+\)[0-9]\+/\1${RunNumber}/" "$ROOT/package.nix"

hash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri $(nix-prefetch-url --unpack "https://github.com/HemantKArya/BloomeeTunes/archive/refs/tags/${latestTag}.tar.gz"))
update-source-version bloomeetunes $latestVersion $hash

curl https://raw.githubusercontent.com/HemantKArya/BloomeeTunes/${latestTag}/pubspec.lock | yq . >$ROOT/pubspec.lock.json
