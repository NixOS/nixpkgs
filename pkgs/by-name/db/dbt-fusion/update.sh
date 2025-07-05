#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl gnused nix-prefetch

set -euo pipefail

ROOT="$(dirname "$(readlink -f "$0")")"
NIX_DRV="$ROOT/package.nix"
if [ ! -f "$NIX_DRV" ]; then
  echo "ERROR: cannot find package.nix in $ROOT"
  exit 1
fi

fetch_dbt_arch() {
  VER="$1"; ARCH="$2"
  URL="https://public.cdn.getdbt.com/fs/cli/fs-v${VER}-${ARCH}.tar.gz"
  nix-hash --to-sri --type sha256 "$(nix-prefetch-url --type sha256 "$URL")"
}

fetch_lsp_arch() {
  VER="$1"; ARCH="$2"
  URL="https://public.cdn.getdbt.com/fs/lsp/fs-lsp-v${VER}-${ARCH}.tar.gz"
  nix-hash --to-sri --type sha256 "$(nix-prefetch-url --type sha256 "$URL")"
}

replace_dbt_hash() {
  sed -i "/\"$1\" = {/,/};/ s#dbtHash = \"sha256-.\{44\}\"#dbtHash = \"$2\"#" "$NIX_DRV"
}

replace_lsp_hash() {
  sed -i "/\"$1\" = {/,/};/ s#lspHash = \"sha256-.\{44\}\"#lspHash = \"$2\"#" "$NIX_DRV"
}

FUSION_VER=$(curl -s "https://public.cdn.getdbt.com/fs/latest.json" | sed -n 's/.*"tag": *"v\([^"]*\)".*/\1/p')

sed -i "s/version = \".*\"/version = \"$FUSION_VER\"/" "$NIX_DRV"

FUSION_LINUX_X64_DBT_HASH=$(fetch_dbt_arch "$FUSION_VER" "x86_64-unknown-linux-gnu")
FUSION_LINUX_AARCH64_DBT_HASH=$(fetch_dbt_arch "$FUSION_VER" "aarch64-unknown-linux-gnu")
FUSION_DARWIN_X64_DBT_HASH=$(fetch_dbt_arch "$FUSION_VER" "x86_64-apple-darwin")
FUSION_DARWIN_AARCH64_DBT_HASH=$(fetch_dbt_arch "$FUSION_VER" "aarch64-apple-darwin")

replace_dbt_hash "x86_64-linux" "$FUSION_LINUX_X64_DBT_HASH"
replace_dbt_hash "aarch64-linux" "$FUSION_LINUX_AARCH64_DBT_HASH"
replace_dbt_hash "x86_64-darwin" "$FUSION_DARWIN_X64_DBT_HASH"
replace_dbt_hash "aarch64-darwin" "$FUSION_DARWIN_AARCH64_DBT_HASH"

FUSION_LINUX_X64_LSP_HASH=$(fetch_lsp_arch "$FUSION_VER" "x86_64-unknown-linux-gnu")
FUSION_LINUX_AARCH64_LSP_HASH=$(fetch_lsp_arch "$FUSION_VER" "aarch64-unknown-linux-gnu")
FUSION_DARWIN_X64_LSP_HASH=$(fetch_lsp_arch "$FUSION_VER" "x86_64-apple-darwin")
FUSION_DARWIN_AARCH64_LSP_HASH=$(fetch_lsp_arch "$FUSION_VER" "aarch64-apple-darwin")

replace_lsp_hash "x86_64-linux" "$FUSION_LINUX_X64_LSP_HASH"
replace_lsp_hash "aarch64-linux" "$FUSION_LINUX_AARCH64_LSP_HASH"
replace_lsp_hash "x86_64-darwin" "$FUSION_DARWIN_X64_LSP_HASH"
replace_lsp_hash "aarch64-darwin" "$FUSION_DARWIN_AARCH64_LSP_HASH"
