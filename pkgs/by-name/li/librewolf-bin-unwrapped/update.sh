#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix curl coreutils jq common-updater-scripts

set -eou pipefail

latestVersion=$(curl ${GITLAB_TOKEN:+-H "Private-Token: $GITLAB_TOKEN"} -sL https://gitlab.com/api/v4/projects/44042130/releases | jq -r '.[0].tag_name')
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; librewolf-bin-unwrapped.version or (lib.getVersion librewolf-bin-unwrapped)" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

for i in \
    "i686-linux linux-i686" \
    "x86_64-linux linux-x86_64" \
    "aarch64-linux linux-arm64"; do
    set -- $i
    hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(curl ${GITLAB_TOKEN:+-H "Private-Token: $GITLAB_TOKEN"} -sL https://gitlab.com/api/v4/projects/44042130/packages/generic/librewolf/$latestVersion/librewolf-$latestVersion-$2-package.tar.xz.sha256sum))
    update-source-version librewolf-bin-unwrapped $latestVersion $hash --system=$1 --ignore-same-version
done
