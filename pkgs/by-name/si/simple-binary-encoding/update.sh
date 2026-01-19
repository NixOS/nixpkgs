#!/usr/bin/env nix-shell
#!nix-shell -I nixpkgs=./. -i bash -p bash nix curl coreutils jq common-updater-scripts

set -eou pipefail

latest=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sL https://api.github.com/repos/aeron-io/simple-binary-encoding/releases/latest)
latestTag=$(echo "$latest" | jq -r ".tag_name")
latestVersion="$latestTag"

currentVersion=$(nix-instantiate --eval -E "with import ./. {}; simple-binary-encoding.version" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

hash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri "$(nix-prefetch-url --unpack "https://github.com/aeron-io/simple-binary-encoding/archive/refs/tags/${latestTag}.tar.gz")")
update-source-version simple-binary-encoding "$latestVersion" "$hash"

"$(nix-build -A simple-binary-encoding.mitmCache.updateScript)"

