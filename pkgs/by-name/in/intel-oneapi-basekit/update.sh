#!/usr/bin/env nix-shell
#!nix-shell -i bash -p ripgrep sd curl nix
set -euo pipefail

# The URLs will look like this:
#   https://registrationcenter-download.intel.com/akdlm/IRC_NAS/bd1d0273-a931-4f7e-ab76-6a2a67d646c7/intel-oneapi-base-toolkit-2025.2.0.592_offline.sh
#                                                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^                           ^^^^^^^^^^^^ ^^^^^^
#                                                               UUID                                                           Version      See below
#
# The code changes with new releases.
#
# Usage:
#   ./update.sh base
#   ./update.sh hpc

# --- Argument Parsing ---
if [[ $# -ne 1 ]]; then
  echo "Error: Missing argument. Please specify 'base' or 'hpc'." >&2
  echo "Usage: $0 <base|hpc>" >&2
  exit 1
fi

nixpkgs="$(git rev-parse --show-toplevel || (printf 'Could not find root of nixpkgs repo\nAre we running from within the nixpkgs git repo?\n' >&2; exit 1))"

KIT_NAME=$1
DOWNLOAD_PAGE_URL=""

# --- Set Kit-Specific Variables ---
case "$KIT_NAME" in
  base)
    DOWNLOAD_PAGE_URL='https://www.intel.com/content/www/us/en/developer/tools/oneapi/base-toolkit-download.html?packages=oneapi-toolkit&oneapi-toolkit-os=linux&oneapi-lin=offline'
    TARGET_FILE="$nixpkgs/pkgs/by-name/in/intel-oneapi-basekit/package.nix"
    ;;
  hpc)
    DOWNLOAD_PAGE_URL='https://www.intel.com/content/www/us/en/developer/tools/oneapi/hpc-toolkit-download.html?packages=hpc-toolkit&hpc-toolkit-os=linux&hpc-toolkit-lin=offline'
    TARGET_FILE="$nixpkgs/pkgs/by-name/in/intel-oneapi-hpckit/package.nix"
    ;;
  *)
    echo "Error: Invalid argument '$KIT_NAME'. Please use 'base' or 'hpc'." >&2
    echo "Usage: $0 <base|hpc>" >&2
    exit 1
    ;;
esac

echo "Updating Intel OneAPI $KIT_NAME Toolkit..."

KIT_PATTERN="https://registrationcenter-download.intel.com/akdlm/IRC_NAS/([0-9a-z-]+)/intel-oneapi-${KIT_NAME}-toolkit-([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)(_offline)?\.sh"

echo "Fetching data from Intel's download page..."
FOUND_URL=$(curl -s "$DOWNLOAD_PAGE_URL" | rg -o "$KIT_PATTERN" || true)

if [[ -z "$FOUND_URL" ]]; then
  echo "Error: Could not find a matching download URL on the page." >&2
  exit 1
fi

echo "Successfully found a URL: $FOUND_URL"

UUID=$(echo "$FOUND_URL" | rg -N "$KIT_PATTERN" --replace '$1')
VERSION=$(echo "$FOUND_URL" | rg -N "$KIT_PATTERN" --replace '$2')

# Reconstruct the URL to ensure it points to the offline installer, as sometimes
# the page only links to the online one (which has the same UUID and version).
FINAL_URL="https://registrationcenter-download.intel.com/akdlm/IRC_NAS/$UUID/intel-oneapi-${KIT_NAME}-toolkit-${VERSION}_offline.sh"

echo "  -> Version: $VERSION"
echo "  -> UUID:    $UUID"
echo "  -> Final URL: $FINAL_URL"
#
# --- Check if version already matches ---
if [[ -f "$TARGET_FILE" ]]; then
  CURRENT_VERSION=$(rg '^\s*version\s*=\s*"([^"]+)"' -o -r '$1' "$TARGET_FILE" || true)
  if [[ "$CURRENT_VERSION" == "$VERSION" ]]; then
    echo "Version $VERSION is already up-to-date in $TARGET_FILE. Skipping update."
    exit 0
  fi
  echo "  -> Current version: $CURRENT_VERSION (will update to $VERSION)"
else
  echo "Error: Target file '$TARGET_FILE' not found." >&2
  exit 1
fi

echo "Prefetching URL to calculate SRI hash..."
SHA=$(nix-prefetch-url --type sha256 "$FINAL_URL")
SRI_SHA=$(nix hash convert --hash-algo sha256 "$SHA")
echo "  -> SRI Hash: $SRI_SHA"

if [[ ! -f "$TARGET_FILE" ]]; then
    echo "Error: Target file '$TARGET_FILE' not found." >&2
    exit 1
fi

echo "Applying updates to $TARGET_FILE..."

sd '(^\s*version\s*=\s*)".*?"' "\$1\"$VERSION\"" "$TARGET_FILE"
sd '(^\s*uuid\s*=\s*)".*?"' "\$1\"$UUID\"" "$TARGET_FILE"
sd '(^\s*sha256\s*=\s*)".*?"' "\$1\"$SRI_SHA\"" "$TARGET_FILE"

echo "Successfully updated $TARGET_FILE."
