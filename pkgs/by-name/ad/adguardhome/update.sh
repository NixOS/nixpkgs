#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl gnugrep jq nix-prefetch nix-update

# This file is based on /pkgs/servers/gotify/update.sh

set -euo pipefail

dirname="$(dirname "$0")"

latest_release=$(curl --silent https://api.github.com/repos/AdguardTeam/AdGuardHome/releases/latest)
version=$(jq -r '.tag_name' <<<"$latest_release")

echo "got version $version"

schema_version=$(curl --silent "https://raw.githubusercontent.com/AdguardTeam/AdGuardHome/${version}/internal/configmigrate/configmigrate.go" \
    | grep -Po '(?<=const LastSchemaVersion uint = )[[:digit:]]+$')

echo "got schema_version $schema_version"

nix-update --subpackage dashboard adguardhome --version $version

sed -i -r -e "s/schema_version\s*?=\s*?.*?;/schema_version = ${schema_version};/" "$dirname/package.nix"
