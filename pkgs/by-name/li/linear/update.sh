#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils curl gnugrep common-updater-scripts
#shellcheck shell=bash

set -eu -o pipefail

source_url="https://releases.linear.app/mac"

version="$(curl -L -I "$source_url" | grep -ioE 'filename="Linear-[0-9]+(\.[0-9]+)*-universal\.dmg"' | grep -oE '[0-9]+(\.[0-9]+)*')"

if [[ -z $version ]]; then
  echo "Could not find the latest Linear version in release headers" >&2
  exit 1
fi

hash=$(nix --extra-experimental-features nix-command hash convert --to sri --hash-algo sha256 "$(nix-prefetch-url --type sha256 "https://releases.linear.app/Linear-${version}-universal.dmg")")

update-source-version linear "$version" "$hash" --ignore-same-version
