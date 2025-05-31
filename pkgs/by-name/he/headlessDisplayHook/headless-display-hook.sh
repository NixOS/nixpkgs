appendToVar prePhases setupHeadlessDisplay

setupHeadlessDisplay() {
  export FONTCONFIG_FILE=@fontconfig_file@
  export XDG_RUNTIME_DIR=$(mktemp -d)
  export XDG_CACHE_HOME=$(mktemp -d)
  export LD_LIBRARY_PATH="@ld_library_path@:${LD_LIBRARY_PATH:-}"
  Xvfb :99 -screen 0 800x600x24 >/dev/null 2>&1 &
  export DISPLAY=:99
}
