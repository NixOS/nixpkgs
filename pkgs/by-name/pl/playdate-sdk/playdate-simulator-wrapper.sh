#!/usr/bin/env bash
set -euo pipefail

USER_SDK_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/playdate-sdk-@version@"
NIX_SDK_DIR="@out@/share/playdate-sdk"

if [ ! -d "$USER_SDK_DIR" ]; then
  echo "Initializing Playdate SDK workspace at $USER_SDK_DIR..."
  mkdir -p "$USER_SDK_DIR"
  cp -r "$NIX_SDK_DIR/." "$USER_SDK_DIR"
  chmod -R u+w "$USER_SDK_DIR"
fi

export PLAYDATE_SDK_PATH="$USER_SDK_DIR"
export LD_LIBRARY_PATH="@ldLibraryPath@"
export XDG_DATA_DIRS="@gsettingsSchemas@:${XDG_DATA_DIRS:-}"

exec "$USER_SDK_DIR/bin/PlaydateSimulator" "$@"
