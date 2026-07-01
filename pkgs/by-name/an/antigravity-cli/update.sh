#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash nix jq curl python3

set -euo pipefail

script_dir="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
package_file="$script_dir/package.nix"
baseUrl=https://storage.googleapis.com/antigravity-public/antigravity-cli

currentVersion=$(grep -oP 'version = "\K[^"]+' "$package_file")
latestVersion=$(curl -fsSL $baseUrl/latest)

if [[ "$currentVersion" == "$latestVersion" ]]; then
    echo "package is up-to-date: $currentVersion"
    exit 0
fi

# urls unfortunately include a weird buildid that make it hard to get
latestWholeVersion=$(curl -fsSL $baseUrl/$latestVersion/manifest.json | jq -r '.platforms."linux-x64".url' | cut -d/ -f6)
latestBuildId=${latestWholeVersion#*-}

declare -A hashes
for system in \
    x86_64-linux \
    aarch64-linux \
    x86_64-darwin \
    aarch64-darwin; do
    case $system in
        x86_64-linux) arch="linux-x64/cli_linux_x64.tar.gz" ;;
        aarch64-linux) arch="linux-arm/cli_linux_arm64.tar.gz" ;;
        aarch64-darwin) arch="darwin-arm/cli_mac_arm64.tar.gz" ;;
        x86_64-darwin) arch="darwin-x64/cli_mac_x64.tar.gz" ;;
    esac
    url="$baseUrl/$latestWholeVersion/$arch"
    hash=$(nix store prefetch-file --json --hash-type sha256 "$url" | jq -r '.hash')
    hashes[$system]=$hash
done

python3 - "$package_file" "$latestVersion" "$latestBuildId" \
    "${hashes[x86_64-linux]}" "${hashes[aarch64-linux]}" \
    "${hashes[aarch64-darwin]}" "${hashes[x86_64-darwin]}" << 'EOF'
import sys
import re

package_file = sys.argv[1]
new_version = sys.argv[2]
new_build_id = sys.argv[3]
hashes = {
    "x86_64-linux": sys.argv[4],
    "aarch64-linux": sys.argv[5],
    "aarch64-darwin": sys.argv[6],
    "x86_64-darwin": sys.argv[7],
}

with open(package_file, 'r') as f:
    content = f.read()

content = re.sub(r'version = "[^"]+";', f'version = "{new_version}";', content)
content = re.sub(r'buildId = "[^"]+";', f'buildId = "{new_build_id}";', content)

for system, new_hash in hashes.items():
    pattern = rf'({system}\s*=\s*fetchurl\s*\{{[^}}]*hash\s*=\s*")[^"]+(")'
    content = re.sub(pattern, rf'\1{new_hash}\2', content)

with open(package_file, 'w') as f:
    f.write(content)
EOF

echo "Successfully updated antigravity-cli to $latestVersion"
