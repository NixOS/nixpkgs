#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix curl coreutils jq common-updater-scripts

set -eou pipefail

latestVersion=$(curl ${CODEBERG_TOKEN:+-H "Authorization: token $CODEBERG_TOKEN"} -H 'accept: application/json' -sL https://codeberg.org/api/v1/repos/librewolf/bsys6/releases/latest | jq -r '.tag_name')
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; librewolf-bin-unwrapped.version or (lib.getVersion librewolf-bin-unwrapped)" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

for i in \
    "x86_64-linux linux-x86_64" \
    "aarch64-linux linux-arm64"; do
    set -- $i
    hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(curl ${CODEBERG_TOKEN:+-H "Authorization: token $CODEBERG_TOKEN"} -sL https://codeberg.org/api/packages/librewolf/generic/librewolf/$latestVersion/librewolf-$latestVersion-$2-package.tar.xz.sha256sum))
    update-source-version librewolf-bin-unwrapped $latestVersion $hash --system=$1 --ignore-same-version
done
