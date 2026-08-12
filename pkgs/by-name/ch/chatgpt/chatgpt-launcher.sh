#!/bin/bash

# SPDX-FileCopyrightText: 2026 Arch Linux Contributors
# SPDX-License-Identifier: 0BSD

set -euo pipefail

app_root="@APP_ROOT@"
app_version="@APP_VERSION@"

user_flags=()
ozone_flags=()

config_home="${XDG_CONFIG_HOME:-}"
if [[ -z "${config_home}" && -n "${HOME:-}" ]]; then
  config_home="${HOME}/.config"
fi

if [[ -n "${config_home}" && -f "${config_home}/codex-flags.conf" ]]; then
  while IFS= read -r flag_line || [[ -n "${flag_line}" ]]; do
    flag_line="${flag_line%%#*}"
    read -r -a flag_parts <<<"${flag_line}"
    user_flags+=("${flag_parts[@]}")
  done <"${config_home}/codex-flags.conf"
fi

# The bundled plugins live in the immutable Nix store. ChatGPT copies their
# file modes into ~/.codex, which makes its staging directories read-only.
# Use OpenAI's resource-path override with a small writable per-version cache.
cache_home="${XDG_CACHE_HOME:-${HOME}/.cache}"
cache_base="${cache_home}/openai-codex-desktop/${app_version}"
cache_resources="${cache_base}/resources"

source_plugins="${app_root}/resources/plugins/openai-bundled"
target_plugins="${cache_resources}/plugins/openai-bundled"

refresh_cache=false

if [[ ! -f "${target_plugins}/.bundle-id" ]]; then
  refresh_cache=true
elif ! cmp -s \
  "${source_plugins}/.bundle-id" \
  "${target_plugins}/.bundle-id"; then
  refresh_cache=true
fi

if [[ "${refresh_cache}" == true ]]; then
  tmp_cache="${cache_base}.tmp.$$"

  rm -rf "${tmp_cache}"
  mkdir -p "${tmp_cache}/resources/plugins"

  cp -a \
    "${source_plugins}" \
    "${tmp_cache}/resources/plugins/"

  chmod -R u+w "${tmp_cache}"

  if [[ -d "${cache_base}" ]]; then
    chmod -R u+w "${cache_base}" 2>/dev/null || true
    rm -rf "${cache_base}"
  fi

  mv "${tmp_cache}" "${cache_base}"
fi

export CODEX_ELECTRON_BUNDLED_PLUGINS_RESOURCES_PATH="${cache_resources}"

# Use native Wayland rendering in Wayland sessions. Chromium's automatic Ozone
# selection can otherwise fall back to XWayland.
if [[ "${XDG_SESSION_TYPE:-}" == wayland || -n "${WAYLAND_DISPLAY:-}" ]]; then
  ozone_flags=(--ozone-platform=wayland)
fi

# Explicit user settings override the automatic Wayland selection.
for flag in "${user_flags[@]}" "$@"; do
  case "${flag}" in
    --ozone-platform=*|--ozone-platform-hint=*)
      ozone_flags=()
      ;;
  esac
done

exec "${app_root}/ChatGPT" \
  "${ozone_flags[@]}" \
  "${user_flags[@]}" \
  "$@"
