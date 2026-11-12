# shellcheck shell=bash

preCheckHooks+=('kvrocksStart')
postCheckHooks+=('kvrocksStop')

kvrocksStart() {
  if [[ ${kvrocksTestPort:-} == "" ]]; then
    kvrocksTestPort=6666
  fi

  mkdir -p "$NIX_BUILD_TOP/run/kvrocks"

  if [[ "${KVROCKS_SOCKET:-}" == "" ]]; then
    KVROCKS_SOCKET="$NIX_BUILD_TOP/run/kvrocks.sock"
  fi
  export KVROCKS_SOCKET

  KVROCKS_CONF="$NIX_BUILD_TOP/run/kvrocks.conf"
  export KVROCKS_CONF

  cat <<EOF >"$KVROCKS_CONF"
bind 127.0.0.1 ::1
unixsocket ${KVROCKS_SOCKET}
port ${kvrocksTestPort}
dir $NIX_BUILD_TOP/run/kvrocks
daemonize no
EOF

  echo 'starting kvrocks'

  @server@ -c "$KVROCKS_CONF" &
  KVROCKS_PID=$!

  echo 'waiting for kvrocks to be ready'
  kvrocks_start_timeout=60
  kvrocks_start_deadline=$((SECONDS + kvrocks_start_timeout))
  while ! @cli@ --scan -s "$KVROCKS_SOCKET"; do
    if ! kill -0 "$KVROCKS_PID" 2>/dev/null; then
      echo "kvrocks exited before becoming ready"
      return 1
    fi
    if (( SECONDS >= kvrocks_start_deadline )); then
      echo "timed out after ${kvrocks_start_timeout}s waiting for kvrocks to be ready"
      return 1
    fi
    sleep 1
  done
}

kvrocksStop() {
  echo 'stopping kvrocks'
  kill "$KVROCKS_PID"
}
