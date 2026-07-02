#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl pcre2 jq common-updater-scripts

set -eu -o pipefail

release_data=$(curl https://api.github.com/repos/alexmercerind2/harmonoid-releases/releases/latest)
version=$(jq -r '.tag_name[1:]' <<< "$release_data")

linux64_hash=$(jq '.assets[] as $item | if $item.name == "harmonoid-linux-x86_64.tar.gz" then $item.digest[7:] else empty end' -r <<< "$release_data")
linux64_hash=$(nix-hash --to-sri --type sha256 "$linux64_hash")

linux_aarch_hash=$(jq '.assets[] as $item | if $item.name == "harmonoid-linux-aarch64.tar.gz" then $item.digest[7:] else empty end' -r <<< "$release_data")
linux_aarch_hash=$(nix-hash --to-sri --type sha256 "$linux_aarch_hash")

macos_hash=$(jq '.assets[] as $item | if $item.name == "harmonoid-macos-universal.dmg" then $item.digest[7:] else empty end' -r <<< "$release_data")
macos_hash=$(nix-hash --to-sri --type sha256 "$macos_hash")

update-source-version harmonoid "$version" "$linux64_hash" --system=x86_64-linux --ignore-same-version
update-source-version harmonoid "$version" "$linux_aarch_hash" --system=aarch64-linux --ignore-same-version
update-source-version harmonoid "$version" "$macos_hash" --system=x86_64-darwin --ignore-same-version
