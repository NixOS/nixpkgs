#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils curl jq common-updater-scripts cargo
# shellcheck shell=bash

set -euo pipefail

SCRIPT_DIRECTORY=$(cd $(dirname ${BASH_SOURCE[0]}); cd -P $(dirname $(readlink ${BASH_SOURCE[0]} || echo .)); pwd)

version=$(curl -s https://api.github.com/repos/huacnlee/autocorrect/releases/latest | jq -r .tag_name)
update-source-version autocorrect "${version#v}"

tmp=$(mktemp -d)
trap 'rm -rf -- "${tmp}"' EXIT

git clone --depth 1 --branch "${version}" https://github.com/huacnlee/autocorrect.git "${tmp}/autocorrect"
cargo generate-lockfile --manifest-path "${tmp}/autocorrect/Cargo.toml"
cp "${tmp}/autocorrect/Cargo.lock" "${SCRIPT_DIRECTORY}/Cargo.lock"
