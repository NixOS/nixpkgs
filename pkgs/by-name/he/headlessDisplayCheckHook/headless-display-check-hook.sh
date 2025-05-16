appendToVar prePhases setupHeadlessDisplay

setupHeadlessDisplay() {
  export XDG_RUNTIME_DIR=$(mktemp -d)
  export XDG_CACHE_HOME=$(mktemp -d)
  mkdir -p /tmp/.X11-unix
  weston --backend=headless-backend.so --xwayland --idle-time=0 >/dev/null &
  export DISPLAY=:0
}
