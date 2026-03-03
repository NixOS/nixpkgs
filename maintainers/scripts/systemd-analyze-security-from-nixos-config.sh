#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix systemd
# shellcheck shell=bash

set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  systemd-analyze-security-from-nixos-config.sh <nixos-config-path> <service-name>

Example:
  systemd-analyze-security-from-nixos-config.sh \
    nixosTests.forgejo.sqlite3.nodes.server \
    forgejo.service

This builds <nixos-config-path>.system.build.etc from the local nixpkgs checkout
and runs systemd-analyze security in offline mode against that root.

Using system.build.etc includes template units and drop-ins, so instance units
like foo@bar.service are analyzed with foo@.service + foo@bar.service.d/*.conf.
EOF
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

if [ "${1-}" = "-h" ] || [ "${1-}" = "--help" ]; then
  usage
  exit 0
fi

[ "$#" -eq 2 ] || {
  usage >&2
  die "expected 2 arguments, got $#"
}

config_path="$1"
service_name="$2"

script_dir="$(dirname "$(readlink -f "$0")")"
repo_root="$(readlink -f "${script_dir}/../..")"

etc_expr="let
  pkgs = import ./. {};
  lib = pkgs.lib;
  configPath = \"${config_path}\";
  path = lib.strings.splitString \".\" configPath;
  cfg = lib.attrByPath path (throw \"configuration path not found: \${configPath}\") pkgs;
in
cfg.system.build.etc or (throw \"missing system.build.etc at: \${configPath}\")"

etc_root="$(
  cd "$repo_root"
  nix build \
    --impure \
    --no-link \
    --print-out-paths \
    --expr "$etc_expr"
)"

exec systemd-analyze security --no-pager --offline=yes --root "$etc_root" "$service_name"
