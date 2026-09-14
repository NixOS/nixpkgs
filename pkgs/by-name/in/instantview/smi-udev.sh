#!/bin/sh
# Udev helper for Silicon Motion USB Display (adapted from vendor/AUR bootstrap).
# Service start/stop is handled via SYSTEMD_WANTS=instantview.service in udev rules.

create_siliconmotion_symlink() {
  root=$1
  device_id=$2
  devnode=$3
  mkdir -p "${root}/siliconmotion/by-id"
  ln -sf "$devnode" "${root}/siliconmotion/by-id/$device_id"
}

unlink_siliconmotion_symlink() {
  root=$1
  devname=$2
  dir="${root}/siliconmotion/by-id"
  [ -d "$dir" ] || return 0
  for f in "$dir"/*; do
    [ -e "$f" ] || [ -L "$f" ] || continue
    if [ ! -e "$f" ] || { [ -L "$f" ] && [ "$f" -ef "$devname" ]; }; then
      unlink "$f" 2>/dev/null || true
    fi
  done
  rmdir -p --ignore-fail-on-non-empty "$dir" 2>/dev/null || true
}

main() {
  action=$1
  root=$2
  case "$action" in
  add)
    device_id=$3
    devnode=$4
    create_siliconmotion_symlink "$root" "$device_id" "$devnode"
    ;;
  remove)
    devname=$3
    unlink_siliconmotion_symlink "$root" "$devname"
    ;;
  esac
}

main "$@"
