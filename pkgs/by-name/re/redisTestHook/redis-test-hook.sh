preCheckHooks+=('redisStart')
postCheckHooks+=('redisStop')


redisStart() {
  if [[ "${redisTestPort:-}" == "" ]]; then
    redisTestPort=6379
  fi

  mkdir -p "$NIX_BUILD_TOP/run"

  if [[ "${REDIS_SOCKET:-}" == "" ]]; then
    REDIS_SOCKET="$NIX_BUILD_TOP/run/redis.sock"
  fi
  export REDIS_SOCKET

  REDIS_CONF="$NIX_BUILD_TOP/run/redis.conf"
  export REDIS_CONF

  cat <<EOF > "$REDIS_CONF"
unixsocket ${REDIS_SOCKET}
port ${redisTestPort}
protected-mode no
enable-debug-command yes
enable-module-command yes
EOF

  echo 'starting redis'

  # Note about Darwin: unless the output is redirected, the parent process becomes launchd instead of bash.
  # This would leave the Redis process running in case of a test failure (the postCheckHook would not be executed),
  # hanging the Nix build forever.
  @server@ "$REDIS_CONF" > /dev/null 2>&1 &
  REDIS_PID=$!

  echo 'waiting for redis to be ready'
  while ! @cli@ --scan -s "$REDIS_SOCKET" ; do
    sleep 1
  done
}

redisStop() {
  echo 'stopping redis'
  kill "$REDIS_PID"
}
