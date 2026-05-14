#!/usr/bin/env nix-shell
#! nix-shell -i bash -p common-updater-scripts curl jq nix-prefetch-github prefetch-npm-deps

set -euo pipefail

latest_version=$(curl -s https://api.github.com/repos/Kareadita/Kavita/releases/latest | jq -r '.tag_name' | tr -d v)

pushd "$(mktemp -d)"
curl -s https://raw.githubusercontent.com/Kareadita/Kavita/v${latest_version}/UI/Web/package-lock.json -o package-lock.json
npmDepsHash=$(prefetch-npm-deps package-lock.json)
rm -f package-lock.json
popd

update-source-version kavita "$latest_version"

pushd "$(dirname "${BASH_SOURCE[0]}")"
sed -E 's#\bnpmDepsHash = ".*?"#npmDepsHash = "'"$npmDepsHash"'"#' -i default.nix
popd

$(nix-build -A kavita.backend.fetch-deps --no-out-link)
