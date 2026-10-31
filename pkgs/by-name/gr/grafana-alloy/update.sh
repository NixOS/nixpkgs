#!/usr/bin/env nix-shell
#! nix-shell -I nixpkgs=./. -i bash -p nix-update curl yq jq

set -euo pipefail

nix-update grafana-alloy --version-regex='^v([0-9.]+)$'

version="$(
  nix-instantiate \
    --eval \
    -E "with import "$(dirname "${BASH_SOURCE[0]}")/../../../.." {}; lib.getVersion grafana-alloy" |
    tr -d \"
)"

beyla_version="$(
  curl -s "https://raw.githubusercontent.com/grafana/alloy/v${version}/internal/component/beyla/ebpf/internal/config/gen/beyla/beyla_version.yaml" |
    yq -r '.version' |
    tr -d v
)"

url() {
  arch="$1"
  printf 'https://github.com/grafana/beyla/releases/download/v%s/beyla-linux-%s-v%s.tar.gz' "$beyla_version" "$arch" "$beyla_version"
}
amd64_url="$(url amd64)"
arm64_url="$(url arm64)"

hash() {
  url="$1"
  nix-prefetch-url "$url" 2>/dev/null |
    xargs nix-hash --type sha256 --to-sri
}
amd64_hash="$(hash "$amd64_url")"
arm64_hash="$(hash "$arm64_url")"

jq \
  --arg amd64_url "$amd64_url" \
  --arg amd64_hash "$amd64_hash" \
  --arg arm64_url "$arm64_url" \
  --arg arm64_hash "$arm64_hash" \
  --null-input '{
  "amd64": {
    "url": $amd64_url,
    "hash": $amd64_hash
  },
  "arm64": {
    "url": $arm64_url,
    "hash": $arm64_hash
  },
}' >"$(dirname "${BASH_SOURCE[0]}")/beyla.json"
