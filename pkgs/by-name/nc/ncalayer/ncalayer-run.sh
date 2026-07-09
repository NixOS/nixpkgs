set -e

export JAVA_HOME="$ncalayer_unwrapped/share/ncalayer/additions/jre8_ncalayer"
export PATH="$JAVA_HOME/bin:$PATH"

# Avoid rendering bugs and blank window glitches on Wayland
export GDK_BACKEND=x11
export _JAVA_AWT_WM_NONREPARENTING=1
export _JAVA_OPTIONS="-Djdk.gtk.version=2 -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true ${_JAVA_OPTIONS:-}"

# pcsclite from targetPkgs will always be available in the standard path due to buildFHSEnv
JAVA_ARGS="-Dsun.security.smartcardio.library=/usr/lib/libpcsclite.so.1"
show_help() {
  echo "Usage: ncalayer [OPTION]"
  echo "NCALayer provides digital signature (EDS) capabilities for Kazakhstan government web portals."
  echo ""
  echo "Options:"
  echo "  -h, --help       Show this help message"
  echo "  --run            Run NCALayer in the background if not already running"
  echo "  --settings       Open NCALayer configuration settings"
  echo "  --bundle-manager Open NCALayer bundle manager"
  echo "  --stop           Stop NCALayer execution"
  echo "  --restart        Restart NCALayer"
  echo ""
  echo "Running without options will start NCALayer in the foreground."
}

wait_for_server() {
  local timeout=60
  while ! (echo > /dev/tcp/127.0.0.1/13579) >/dev/null 2>&1; do
    sleep 0.5
    timeout=$((timeout - 1))
    if [ $timeout -le 0 ]; then
      echo "Error: Timed out waiting for NCALayer socket (127.0.0.1:13579)." >&2
      exit 1
    fi
  done
}

start_background() {
  if ! pgrep -f "ncalayer.sh" > /dev/null; then
    java $JAVA_ARGS -jar "$ncalayer_unwrapped/share/ncalayer/ncalayer.sh" >/dev/null 2>&1 &
  fi
}

case "$1" in
  -h|--help)
    show_help
    exit 0
    ;;
  --run)
    if pgrep -f "ncalayer.sh" > /dev/null; then
      echo "NCALayer is already running. You can use --stop or --restart."
      exit 1
    fi
    java $JAVA_ARGS -jar "$ncalayer_unwrapped/share/ncalayer/ncalayer.sh" >/dev/null 2>&1 &
    ;;
  --settings)
    start_background
    wait_for_server
    "$ncalayer_unwrapped/share/ncalayer/additions/showSettings"
    ;;
  --bundle-manager)
    start_background
    wait_for_server
    "$ncalayer_unwrapped/share/ncalayer/additions/showBundleManager"
    ;;
  --stop)
    pkill -f "ncalayer.sh" || true
    exit 0
    ;;
  --restart)
    pkill -f "ncalayer.sh" || true
    while (echo > /dev/tcp/127.0.0.1/13579) >/dev/null 2>&1; do sleep 0.5; done
    java $JAVA_ARGS -jar "$ncalayer_unwrapped/share/ncalayer/ncalayer.sh" >/dev/null 2>&1 &
    ;;
  "")
    java $JAVA_ARGS -jar "$ncalayer_unwrapped/share/ncalayer/ncalayer.sh"
    ;;
  *)
    echo "Unknown option: $1" >&2
    show_help
    exit 1
    ;;
esac
