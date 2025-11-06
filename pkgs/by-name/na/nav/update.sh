#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq common-updater-scripts
set -eou pipefail

version=$(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sfL "https://api.github.com/repos/Jojo4GH/nav/releases/latest" | jq -r .tag_name | sed 's/v//')

for cpu in "x86_64" "aarch64"; do

    hash=$(nix-hash --type sha256 --to-sri $(curl ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} -sfL "https://github.com/Jojo4GH/nav/releases/download/v$version/nav-$cpu-unknown-linux-gnu.tar.gz.sha256"))
    update-source-version nav $version $hash --system=$cpu-linux --ignore-same-version
done
