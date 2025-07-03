#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix curl coreutils jq common-updater-scripts

set -eou pipefail

latestVersion=$(curl -s "https://s3-us-west-2.amazonaws.com/confluent.cloud?prefix=confluent-cli/archives/&delimiter=/" |
    sed 's/></>\n</g' |
    grep '<Prefix>confluent-cli/archives/' |
    sed -n 's#<Prefix>confluent-cli/archives/\(v\?\)\([^/]*\)/</Prefix>#\2#p' |
    grep -v '^latest$' |
    sort --version-sort |
    tail -n1)
currentVersion=$(nix-instantiate --eval -E "with import ./. {}; confluent-cli.version or (lib.getVersion confluent-cli)" | tr -d '"')

echo "latest  version: $latestVersion"
echo "current version: $currentVersion"

if [[ "$latestVersion" == "$currentVersion" ]]; then
    echo "package is up-to-date"
    exit 0
fi

for i in \
    "x86_64-linux linux_amd64" \
    "aarch64-linux linux_arm64" \
    "x86_64-darwin darwin_amd64" \
    "aarch64-darwin darwin_arm64"; do
    set -- $i
    hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 $(nix-prefetch-url "https://s3-us-west-2.amazonaws.com/confluent.cloud/confluent-cli/archives/$latestVersion/confluent_${latestVersion}_$2.tar.gz"))
    update-source-version confluent-cli $latestVersion $hash --system=$1 --ignore-same-version
done
