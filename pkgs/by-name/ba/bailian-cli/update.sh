#!/usr/bin/env nix
#!nix shell --ignore-environment .#cacert .#coreutils .#curl .#bash --command bash

set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")"

# The release manifest lists every published asset together with its checksum,
# which is what package.nix reads.
curl -fsSL "https://bailian-wiki.oss-cn-hangzhou.aliyuncs.com/release/manifest.json" --output manifest.json
