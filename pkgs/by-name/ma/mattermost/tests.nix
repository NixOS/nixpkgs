{
  lib,
  mattermost,
  gotestsum,
  which,
  postgresql,
  redis,
  curl,
  net-tools,
  runtimeShell,
}:

mattermost.overrideAttrs (
  final: prev: {
    doCheck = true;
    checkTargets = [
      "test-mmctl"
    ];
    nativeCheckInputs = [
      which
      postgresql
      redis
      curl
      net-tools
      gotestsum
    ];

    postPatch = prev.postPatch or "" + ''
      # Just echo install/get/mod commands in the Makefile, since the dependencies are locked.
      substituteInPlace server/Makefile \
        --replace-warn '$(GO) install' 'echo $(GO) install' \
        --replace-warn '$(GOBIN)/go$$version download' 'echo $(GOBIN)/go$$version download' \
        --replace-warn '$(GO) get' 'echo $(GO) get' \
        --replace-warn '$(GO) get' 'echo $(GO) mod'
      # mmctl tests shell out by writing a bash script to a tempfile
      substituteInPlace server/cmd/mmctl/commands/config_e2e_test.go \
        --replace-fail '#!/bin/bash' '#!${runtimeShell}'
    '';

    # Make sure we disable tests that are broken.
    # Use: `nix log <drv> | grep FAIL: | awk '{print $3}' | sort`
    # and then try to pick the most specific test set to disable, such as:
    # X  TestFoo
    # X  TestFoo/TestBar
    # -> TestFoo/TestBar/baz_test
    disabledTests = lib.lists.uniqueStrings [
      # All these plugin tests for mmctl reach out to the marketplace, which is impossible in the sandbox
      "TestMmctlE2ESuite/TestPluginDeleteCmd/Delete_Plugin/SystemAdminClient"
      "TestMmctlE2ESuite/TestPluginDeleteCmd/Delete_Plugin/LocalClient"
      "TestMmctlE2ESuite/TestPluginDeleteCmd/Delete_a_Plugin_without_permissions"
      "TestMmctlE2ESuite/TestPluginDeleteCmd/Delete_Unknown_Plugin/SystemAdminClient"
      "TestMmctlE2ESuite/TestPluginDeleteCmd/Delete_Unknown_Plugin/LocalClient"
      "TestMmctlE2ESuite/TestPluginInstallURLCmd"
      "TestMmctlE2ESuite/TestPluginMarketplaceInstallCmd"
      "TestMmctlE2ESuite/TestPluginMarketplaceInstallCmd"
      "TestMmctlE2ESuite/TestPluginMarketplaceListCmd"
    ];

    preCheck = ''
      cleanup() {
        runHook postCheck
      }
      trap cleanup EXIT

      # Runs an iteration of the wait loop.
      # Returns 0 if we should retry, 1 otherwise.
      _wait_loop() {
        local process="$1"
        local direction="$2"
        echo "Waiting for $process to go $direction ($_TRIES attempt(s) left)..." >&2
        _TRIES=$((_TRIES-1))
        if [ $_TRIES -le 0 ]; then
          return 1
        else
          sleep 1
          return 0
        fi
      }

      # Waits on a command named '$1' with direction '$2'.
      # The rest of the command is specified in $@.
      # If the direction is up, waits for the command to succeed at 1 second intervals.
      # If it's down, waits for the command to fail at 1 second intervals.
      # Uses a maximum of 5 iterations. Returns 0 if all was ok, or 1 if we timed out.
      wait_cmd() {
        local process="$1"
        local direction="$2"
        local tries=10
        _TRIES=$tries
        shift; shift
        if [ "$direction" == "up" ]; then
          while ! "$@" &>/dev/null; do
            if ! _wait_loop "$process" "$direction"; then
              break
            fi
          done
        else
          while "$@" &>/dev/null; do
            if ! _wait_loop "$process" "$direction"; then
              break
            fi
          done
        fi

        if [ $_TRIES -le 0 ]; then
          echo "Timed out after $tries tries" >&2
          return 1
        else
          echo "OK, $process went $direction." >&2
          return 0
        fi
      }

      # Waits for Postgres to come up or down.
      wait_postgres() {
        wait_cmd postgres "$1" pg_isready -h localhost
      }

      # Waits for Redis to come up or down.
      wait_redis() {
        wait_cmd redis "$1" redis-cli ping
      }

      # Starts Postgres.
      start_postgres() {
        echo "Starting Postgres at $PGDATA" >&2
        pg_ctl start
        wait_postgres up
      }

      # Stops Postgres.
      stop_postgres() {
        echo "Terminating Postgres at $PGDATA" >&2
        pg_ctl stop
        wait_postgres down
      }

      # Starts redis.
      start_redis() {
        echo "Starting Redis" >&2
        (cd "$REDIS_HOME" && exec redis-server ./redis.conf) &
        redis_pid=$!
        echo "... PID $redis_pid" >&2
        wait_redis up
      }

      # Stops redis.
      stop_redis() {
        echo "Stopping Redis" >&2
        kill -TERM "$redis_pid" >&2
        wait_redis down
        redis_pid=0
      }

      # Start Postgres.
      export PGDATA="$NIX_BUILD_TOP/.postgres"
      initdb -E UTF8 -U postgres
      mkdir -p "$PGDATA/run"
      cat <<EOF >> "$PGDATA/postgresql.conf"
      unix_socket_directories = '$PGDATA/run'
      max_connections = 256
      shared_buffers = 96MB
      EOF
      start_postgres

      # Init Postgres.
      cat <<EOF | psql -U postgres -h localhost
      -- This is the admin password for tests; see the docker-compose:
      -- https://github.com/mattermost/mattermost/blob/v${final.version}/server/docker-compose.yaml
      create user mmuser superuser password 'mostest';
      create database mattermost_test;
      grant all on database mattermost_test to mmuser;
      alter database mattermost_test owner to mmuser;
      EOF

      # Configure Redis.
      export REDIS_HOME="$NIX_BUILD_TOP/.redis"
      mkdir -p "$REDIS_HOME"
      cat <<EOF > "$REDIS_HOME/redis.conf"
      bind 127.0.0.1
      port 6379
      protected-mode no
      EOF

      # Start Redis.
      start_redis

      # Use gotestsum from nixpkgs instead of installing it ourselves.
      mkdir -p bin
      ln -s "$(which gotestsum)" bin/gotestsum
    '';

    checkPhase = ''
      runHook preCheck

      # Ensure we parallelize the tests, and skip the correct ones.
      # Spaces are important here due to how the Makefile works.
      export GOFLAGS=" -p=$NIX_BUILD_CORES -parallel=$NIX_BUILD_CORES -skip='$(echo "$disabledTests" | tr ' ' '|')' "

      # ce n'est pas un conteneur
      MMCTL_TESTFLAGS="$GOFLAGS" MM_NO_DOCKER=true make $checkTargets

      runHook postCheck
    '';

    postCheck = ''
      # Clean up Postgres.
      if [ -d "$PGDATA" ]; then
        stop_postgres
        rm -rf "$PGDATA"
      fi

      # Clean up Redis.
      if [ -d "$REDIS_HOME" ]; then
        stop_redis
        rm -rf "$REDIS_HOME"
      fi

      # Delete the gotestsum link.
      rm -f bin/gotestsum
    '';
  }
)
