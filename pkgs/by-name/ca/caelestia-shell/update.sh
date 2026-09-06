#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl jq python3 nix

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
PKG_NIX="$ROOT/package.nix"

TAG="$(curl -sL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} https://api.github.com/repos/caelestia-dots/shell/releases/latest | jq -r .tag_name)"
VERSION="${TAG#v}"

REV="$(curl -sL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://api.github.com/repos/caelestia-dots/shell/commits/$TAG" | jq -r .sha)"

TAR_URL="https://github.com/caelestia-dots/shell/releases/download/v${VERSION}/caelestia-shell-v${VERSION}.tar.gz"
SHELL_RAW="$(nix-prefetch-url "$TAR_URL" 2>/dev/null | tail -n 1)"
SHELL_SRI="$(nix hash convert --to sri --hash-algo sha256 "$SHELL_RAW")"

CMAKE_TXT="$(curl -sL ${GITHUB_TOKEN:+-u ":$GITHUB_TOKEN"} "https://raw.githubusercontent.com/caelestia-dots/shell/$REV/CMakeLists.txt")"
M3_REV="$(echo "$CMAKE_TXT" | grep "set(M3SHAPES_REV" | awk '{print $2}' | tr -d ')')"
M3_RAW="$(nix-prefetch-url --unpack "https://github.com/soramanew/m3shapes/archive/$M3_REV.tar.gz" 2>/dev/null | tail -n 1)"
M3_SRI="$(nix hash convert --to sri --hash-algo sha256 "$M3_RAW")"

python3 - << PY
import re

with open("$PKG_NIX", "r") as f:
    content = f.read()

content = re.sub(r'version\s*=\s*"[^"]+";', f'version = "$VERSION";', content, count=1)
content = re.sub(r'rev\s*=\s*"[^"]+";', f'rev = "$REV";', content, count=1)

m3_pattern = r'(m3shapes_src\s*=\s*fetchFromGitHub\s*\{[^}]*?rev\s*=\s*")[^"]+(";\s*hash\s*=\s*")[^"]+(";\s*\};)'
content = re.sub(m3_pattern, rf'\g<1>$M3_REV\g<2>$M3_SRI\g<3>', content, flags=re.DOTALL)

shell_pattern = r'(shellSrc\s*=\s*fetchurl\s*\{[^}]*?hash\s*=\s*")[^"]+(";\s*\};)'
content = re.sub(shell_pattern, rf'\g<1>$SHELL_SRI\g<2>', content, flags=re.DOTALL)

with open("$PKG_NIX", "w") as f:
    f.write(content)
PY

echo "Successfully updated caelestia-shell to $VERSION ($REV)"
