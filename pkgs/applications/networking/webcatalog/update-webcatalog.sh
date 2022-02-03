#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnugrep gnused gawk

# Update script for the webcatalog versions and hashes.
# Usually doesn't need to be called by hand,
# but is called by a bot: https://github.com/samuela/nixpkgs-upkeep/actions
# Call it by hand if the bot fails to automatically update the versions.

set -eou pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
if [ ! -f "$ROOT/webcatalog.nix" ]; then
  echo "ERROR: cannot find webcatalog.nix in $ROOT"
  exit 1
fi

WEBCATALOG_VER=$(curl -s -L  https://api.github.com/repos/webcatalog/webcatalog-app/releases/latest | ggrep -oP '(?<="tag_name": "v)[^"]*')
sed -i "s/version = \".*\"/version = \"${WEBCATALOG_VER}\"/" "$ROOT/webcatalog.nix"

WEBCATALOG_LINUX_URL="https://github.com/webcatalog/webcatalog-app/releases/download/v${WEBCATALOG_VER}/WebCatalog-${WEBCATALOG_VER}.tar.gz"
WEBCATALOG_LINUX_SHA256=$(nix-prefetch-url ${WEBCATALOG_LINUX_URL})
sed -i "s/x86_64-linux = \".\{52\}\"/x86_64-linux = \"${WEBCATALOG_LINUX_SHA256}\"/" "$ROOT/vscode.nix"

WEBCATALOG_DARWIN_URL="https://github.com/webcatalog/webcatalog-app/releases/download/v${WEBCATALOG_VER}/WebCatalog-${WEBCATALOG_VER}-mac.zip"
WEBCATALOG_DARWIN_SHA256=$(nix-prefetch-url ${WEBCATALOG_DARWIN_URL})
sed -i "s/x86_64-darwin = \".\{52\}\"/x86_64-darwin = \"${WEBCATALOG_DARWIN_SHA256}\"/" "$ROOT/webcatalog.nix"
