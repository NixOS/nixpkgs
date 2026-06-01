# shellcheck shell=bash

# This setup hook, for each output, moves everything in
# $output/lib/systemd/user to $output/share/systemd/user, and replaces
# $output/lib/systemd/user with a symlink to
# $output/share/systemd/user.

fixupOutputHooks+=(_moveSystemdUserUnits)

_moveSystemdUserUnits() {
    if [ "${dontMoveSystemdUserUnits:-0}" = 1 ]; then return; fi
    if [ ! -e "${prefix:?}/lib/systemd/user" ]; then return; fi
    local source="$prefix/lib/systemd/user"
    local target="$prefix/share/systemd/user"
    echo "moving $source/* to $target"
    mkdir -p "$target"
    (
      shopt -s dotglob
      for i in "$source"/*; do
          mv "$i" "$target"
      done
    )
    rmdir "$source"
    ln -s "$target" "$source"
}
