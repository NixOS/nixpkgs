appendToVar prePhases setupHeadlessDisplay

setupHeadlessDisplay() {
  export FONTCONFIG_FILE=@fontconfig_file@
  export XDG_RUNTIME_DIR=$(mktemp -d)
  export XDG_CACHE_HOME=$(mktemp -d)
  export LD_LIBRARY_PATH="@ld_library_path@:${LD_LIBRARY_PATH:-}"
  mkdir -p /tmp/.X11-unix
  weston --backend=headless-backend.so --xwayland --idle-time=0 >/dev/null &
  export DISPLAY=:0
}
