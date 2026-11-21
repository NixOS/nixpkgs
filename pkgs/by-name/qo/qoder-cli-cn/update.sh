#!/usr/bin/env nix
#!nix shell --ignore-environment .#cacert .#coreutils .#curl .#bash --command bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

# The `latest` channel manifest lists every published platform build together
# with its checksum, which is what package.nix reads.
curl -fsSL "https://static.qoder.com.cn/qoder-cli-cn/channels/manifest.json" --output manifest.json
