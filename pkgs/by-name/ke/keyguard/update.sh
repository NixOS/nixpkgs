#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix curl coreutils jq common-updater-scripts

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"

latest=$(curl -sL https://api.github.com/repos/AChep/keyguard-app/releases/latest)
latestTag=$(echo "$latest" | jq -r ".tag_name")
latestName=$(echo "$latest" | jq -r ".name")
latestVersion=$(echo "$latestName" | awk -F'v|-' '{print $2}')


echo "latest  version: $latestVersion"
echo "current version: $UPDATE_NIX_OLD_VERSION"

if [[ "$latestVersion" == "$UPDATE_NIX_OLD_VERSION" ]]; then
    echo "package is up-to-date"
    exit 0
fi

hash=$(nix --extra-experimental-features nix-command hash convert --hash-algo sha256 --to sri $(nix-prefetch-url --unpack "https://github.com/AChep/keyguard-app/archive/refs/tags/${latestTag}.tar.gz"))
update-source-version keyguard $latestVersion $hash

sed -i 's/tag = "r[0-9]\+\(\.[0-9]\+\)\?";/tag = "'"$latestTag"'";/g' "$ROOT/package.nix"

# the only thing preventing us simply using `nix-update-script` is the weird
# tagging practice of upstream
nix-update --version skip keyguard --subpackage sshAgent
