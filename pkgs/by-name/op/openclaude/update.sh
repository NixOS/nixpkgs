#!/usr/bin/env nix
#!nix shell nixpkgs#bash nixpkgs#nodejs_22 nixpkgs#git nixpkgs#curl nixpkgs#jq nixpkgs#nix-prefetch-github nixpkgs#prefetch-npm-deps nixpkgs#gnused --command bash

set -euo pipefail

# --- Formatting ---
BLUE="\e[34m"
GREEN="\e[32m"
RED="\e[31m"
YELLOW="\e[33m"
BOLD="\e[1m"
RESET="\e[0m"

info() { echo -e "${BLUE}[INFO]${RESET} $1"; }
success() { echo -e "${GREEN}[SUCCESS]${RESET} $1"; }
warn() { echo -e "${YELLOW}[WARN]${RESET} $1"; }
error() {
  echo -e "${RED}[ERROR]${RESET} $1" >&2
  exit 1
}

# --- Setup ---
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NIX_FILE="$DIR/package.nix"
LOCKFILE="$DIR/package-lock.json"
REPO="https://github.com/Gitlawb/openclaude.git"

# --- Fetch Metadata ---
info "Fetching upstream metadata..."
BRANCH=$(git ls-remote --symref "$REPO" HEAD | awk '/^ref:/ { sub("refs/heads/", "", $2); print $2 }')
[ -z "$BRANCH" ] && error "Could not resolve default branch."

VERSION=$(curl -sSL "https://raw.githubusercontent.com/Gitlawb/openclaude/$BRANCH/package.json" | jq -r .version)
[ -z "$VERSION" ] || [ "$VERSION" = "null" ] && error "Could not parse version from package.json."

CURRENT=$(grep 'version = "' "$NIX_FILE" | sed -nE 's/.*version = "([^"]+)";/\1/p' || true)

# --- Version Check ---
if [ "$VERSION" = "$CURRENT" ]; then
  success "Up to date ($VERSION). Exiting."
  exit 0
fi

warn "Updating $CURRENT -> $VERSION"

# --- Lockfile Generation ---
info "Generating package-lock.json..."
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# CLONE OF THE EXACT TAG
git -c advice.detachedHead=false clone --quiet --depth 1 --branch "v$VERSION" "$REPO" "$tmp/src"
(cd "$tmp/src" && npm install --package-lock-only --ignore-scripts --silent)
cp "$tmp/src/package-lock.json" "$LOCKFILE"
success "Lockfile generated."

# --- Prefetch Hashes ---
info "Calculating hashes..."
SRC_HASH=$(nix-prefetch-github Gitlawb openclaude --rev "v$VERSION" 2>/dev/null | jq -r .hash || true)
[ -z "$SRC_HASH" ] && error "Failed to prefetch source hash."
success "Source: ${GREEN}$SRC_HASH${RESET}"

DEPS_HASH=$(prefetch-npm-deps "$LOCKFILE" || true)
[ -z "$DEPS_HASH" ] && error "Failed to prefetch npm deps hash."
success "Deps:   ${GREEN}$DEPS_HASH${RESET}"

# --- Patching ---
info "Patching package.nix..."
sed -i "s|version = \"[^\"]*\";|version = \"$VERSION\";|" "$NIX_FILE"
sed -i "s|hash = \"sha256-[^\"]*\";|hash = \"$SRC_HASH\";|" "$NIX_FILE"
sed -i "s|npmDepsHash = \"sha256-[^\"]*\";|npmDepsHash = \"$DEPS_HASH\";|" "$NIX_FILE"

success "Update complete."
