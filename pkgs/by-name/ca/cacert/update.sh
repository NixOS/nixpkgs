#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix common-updater-scripts jq

set -ex

BASEDIR="$(dirname "$0")/../../../.."

NSS_VERSION=$(nix-instantiate --json --eval -E "with import $BASEDIR {}; nss_latest.version" | jq -r .)
update-source-version cacert "$NSS_VERSION"
