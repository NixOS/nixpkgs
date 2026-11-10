#!@bash@

set -euo pipefail

export HALO_DATA_ROOT="${HALO_DATA_ROOT:-${XDG_DATA_HOME:-$HOME/.local/share}/opence}"
export HALO_SAVE_ROOT="${HALO_SAVE_ROOT:-$HALO_DATA_ROOT/saves}"
config_file="${HALO_CONFIG_FILE:-${XDG_CONFIG_HOME:-$HOME/.config}/opence/config.toml}"

mkdir -p "$HALO_DATA_ROOT" "$HALO_SAVE_ROOT" "$(dirname -- "$config_file")"
if [ ! -e "$HALO_DATA_ROOT/maps" ] || [ -L "$HALO_DATA_ROOT/maps" ]; then
  ln -sfn @out@/share/opence/maps "$HALO_DATA_ROOT/maps"
fi

# OpenCE uses the first --config argument; keep the user's arguments first.
exec @opence@ "$@" --config "$config_file"
