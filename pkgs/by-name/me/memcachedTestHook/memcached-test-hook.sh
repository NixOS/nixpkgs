preCheckHooks+=('memcachedStart')
postCheckHooks+=('memcachedStop')


memcachedStart() {
  if [[ "${memcachedTestPort:-}" == "" ]]; then
    memcachedTestPort=11211
  fi

  echo 'starting memcached'

  # Note about Darwin: unless the output is redirected, the parent process becomes launchd instead of bash.
  # This would leave the memcached process running in case of a test failure (the postCheckHook would not be executed),
  # hanging the Nix build forever.
  @memcached@ -p "$memcachedTestPort" >/dev/null 2>&1 &
  MEMCACHED_PID=$!

  echo 'waiting for memcached to be ready'
  while ! (echo 'quit' | @nc@ localhost "$memcachedTestPort") ; do
    sleep 1
  done
}

memcachedStop() {
  echo 'stopping memcached'
  kill "$MEMCACHED_PID"
}
