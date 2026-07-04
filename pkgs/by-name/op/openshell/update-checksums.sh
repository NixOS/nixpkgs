#!/usr/bin/env bash
set -euo pipefail

REPO="NVIDIA/OpenShell"
BASE_URL="https://github.com/${REPO}/releases/download"
VERSIONS_FILE="$(dirname "$0")/versions.json"

usage() {
  echo "Usage: $0 <version>"
  echo ""
  echo "Fetches SHA256 checksums from GitHub releases and updates versions.json."
  exit 1
}

[[ $# -lt 1 ]] && usage

VERSION="$1"
echo "Fetching checksums for version ${VERSION}..."

TMPDIR=$(mktemp -d)
trap 'rm -rf "$TMPDIR"' EXIT

checksum_files=(
  "openshell-checksums-sha256.txt"
  "openshell-gateway-checksums-sha256.txt"
  "openshell-sandbox-checksums-sha256.txt"
)

for file in "${checksum_files[@]}"; do
  url="${BASE_URL}/v${VERSION}/${file}"
  echo "  Downloading ${file}..."
  if ! curl -sL -o "${TMPDIR}/${file}" "$url"; then
    echo "ERROR: Failed to download ${url}"
    exit 1
  fi
done

export VERSIONS_FILE VERSION TMPDIR

# Use python3 to parse all checksum files and write JSON
python3 -c '
import json
import os

versions_file = os.environ["VERSIONS_FILE"]
version = os.environ["VERSION"]
tmpdir = os.environ["TMPDIR"]

platform_map = {
    "openshell-x86_64-unknown-linux-musl.tar.gz": ("main", "x86_64-linux"),
    "openshell-aarch64-unknown-linux-musl.tar.gz": ("main", "aarch64-linux"),
    "openshell-aarch64-apple-darwin.tar.gz": ("main", "aarch64-darwin"),
    "openshell-driver-vm-x86_64-unknown-linux-gnu.tar.gz": ("driver", "x86_64-linux"),
    "openshell-driver-vm-aarch64-unknown-linux-gnu.tar.gz": ("driver", "aarch64-linux"),
    "openshell-driver-vm-aarch64-apple-darwin.tar.gz": ("driver", "aarch64-darwin"),
    "openshell-gateway-x86_64-unknown-linux-gnu.tar.gz": ("gateway", "x86_64-linux"),
    "openshell-gateway-aarch64-unknown-linux-gnu.tar.gz": ("gateway", "aarch64-linux"),
    "openshell-sandbox-x86_64-unknown-linux-gnu.tar.gz": ("sandbox", "x86_64-linux"),
    "openshell-sandbox-aarch64-unknown-linux-gnu.tar.gz": ("sandbox", "aarch64-linux"),
}

checksums = {}

for checksum_file in ["openshell-checksums-sha256.txt", "openshell-gateway-checksums-sha256.txt", "openshell-sandbox-checksums-sha256.txt"]:
    filepath = os.path.join(tmpdir, checksum_file)
    if not os.path.exists(filepath):
        continue
    with open(filepath) as f:
        for line in f:
            parts = line.strip().split("  ", 1)
            if len(parts) != 2:
                continue
            hash_val, filename = parts
            if filename in platform_map:
                category, platform = platform_map[filename]
                checksums[(category, platform)] = hash_val

if os.path.exists(versions_file):
    with open(versions_file) as f:
        data = json.load(f)
else:
    data = {}

entry = {}
for (category, platform), hash_val in sorted(checksums.items()):
    if category not in entry:
        entry[category] = {}
    entry[category][platform] = hash_val

data[version] = entry

with open(versions_file, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")

print(f"  Written {len(checksums)} checksums to {versions_file}")
'

echo ""
echo "Done! Update package.nix to version ${VERSION}."
