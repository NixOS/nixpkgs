{
  lib,
  stdenv,
  mattermost,
  gotestsum,
  which,
  postgresql,
  mariadb,
  redis,
  curl,
  net-tools,
  runtimeShell,
}:

let
  inherit (lib.lists) optionals;
  inherit (lib.strings) versionAtLeast;
  is10 = version: versionAtLeast version "10.0";
in
mattermost.overrideAttrs (
  final: prev: {
    doCheck = true;
    checkTargets = [
      "test-server"
      "test-mmctl"
    ];
    nativeCheckInputs = [
      which
      postgresql
      mariadb
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
    disabledTests = [
      # All these plugin tests for mmctl reach out to the marketplace, which is impossible in the sandbox
      "TestMmctlE2ESuite/TestPluginDeleteCmd/Delete_Plugin/SystemAdminClient"
      "TestMmctlE2ESuite/TestPluginDeleteCmd/Delete_Plugin/LocalClient"
      "TestMmctlE2ESuite/TestPluginDeleteCmd/Delete_a_Plugin_without_permissions"
      "TestMmctlE2ESuite/TestPluginDeleteCmd/Delete_Unknown_Plugin/SystemAdminClient"
      "TestMmctlE2ESuite/TestPluginDeleteCmd/Delete_Unknown_Plugin/LocalClient"
      "TestMmctlE2ESuite/TestPluginInstallURLCmd/install_new_plugins/SystemAdminClient"
      "TestMmctlE2ESuite/TestPluginInstallURLCmd/install_new_plugins/LocalClient"
      "TestMmctlE2ESuite/TestPluginInstallURLCmd/install_an_already_installed_plugin_without_force/SystemAdminClient"
      "TestMmctlE2ESuite/TestPluginInstallURLCmd/install_an_already_installed_plugin_without_force/LocalClient"
      "TestMmctlE2ESuite/TestPluginInstallURLCmd/install_an_already_installed_plugin_with_force/SystemAdminClient"
      "TestMmctlE2ESuite/TestPluginInstallURLCmd/install_an_already_installed_plugin_with_force/LocalClient"
      "TestMmctlE2ESuite/TestPluginMarketplaceInstallCmd/install_a_plugin/SystemAdminClient"
      "TestMmctlE2ESuite/TestPluginMarketplaceInstallCmd/install_a_plugin/LocalClient"
      "TestMmctlE2ESuite/TestPluginMarketplaceListCmd/List_Marketplace_Plugins_for_Admin_User/SystemAdminClient"
      "TestMmctlE2ESuite/TestPluginMarketplaceListCmd/List_Marketplace_Plugins_for_Admin_User/LocalClient"

      # Seems to just be broken.
      "TestMmctlE2ESuite/TestPreferenceUpdateCmd"

      # Has a hardcoded "google.com" test which also verifies that the address isn't loopback,
      # so we also can't just substituteInPlace to one that will resolve
      "TestDialContextFilter"

      # No interfaces but loopback in the sandbox, so returns empty
      "TestGetServerIPAddress"

      # S3 bucket tests (needs Minio)
      "TestInsecureMakeBucket"
      "TestMakeBucket"
      "TestListDirectory"
      "TestTimeout"
      "TestStartServerNoS3Bucket"
      "TestS3TestConnection"
      "TestS3FileBackendTestSuite"
      "TestS3FileBackendTestSuiteWithEncryption"
      "TestWriteFileVideoMimeTypes"

      # Mail tests (needs a SMTP server)
      "TestSendMailUsingConfig"
      "TestSendMailUsingConfigAdvanced"
      "TestSendMailWithEmbeddedFilesUsingConfig"
      "TestSendCloudWelcomeEmail"
      "TestMailConnectionAdvanced"
      "TestMailConnectionFromConfig"
      "TestEmailTest"
      "TestBasicAPIPlugins/test_send_mail_plugin"

      # Seems to be unreliable
      "TestPluginAPIUpdateUserPreferences"
      "TestPluginAPIGetUserPreferences"

      # These invite tests try to send a welcome email and we don't have a SMTP server up.
      "TestInviteUsersToTeam"
      "TestInviteGuestsToTeam"
      "TestSendInviteEmails"
      "TestDeliver"

      # https://github.com/mattermost/mattermost/issues/29184
      "TestUpAndDownMigrations/Should_be_reversible_for_mysql"
    ]
    ++ optionals (is10 final.version) [
      ## mattermostLatest test ignores

      # These bot related tests appear to be broken.
      "TestCreateBot"
      "TestPatchBot"
      "TestGetBot"
      "TestEnableBot"
      "TestDisableBot"
      "TestAssignBot"
      "TestConvertBotToUser"

      # Need Elasticsearch or Opensearch
      "TestBlevePurgeIndexes"
      "TestOpensearchAggregation"
      "TestOpensearchInterfaceTestSuite"
      "TestOpenSearchIndexerJobIsEnabled"
      "TestOpenSearchIndexerPending"
      "TestBulkProcessor"
      "TestElasticsearchAggregation"
      "TestElasticsearchInterfaceTestSuite"
      "TestElasticSearchIndexerJobIsEnabled"
      "TestElasticSearchIndexerPending"

      # Broken in the sandbox.
      "TestVersion"
      "TestRunServerNoSystemd"

      # Appear to be broken.
      "TestSessionStore/MySQL"
      "TestAccessControlPolicyStore/MySQL"
      "TestAttributesStore/MySQL"
      "TestBasicAPIPlugins"

      "TestRunExportJobE2EByType"
      "TestUpdateTeam"
      "TestSyncSyncableRoles"
    ]
    ++ optionals (!stdenv.hostPlatform.isx86_64) [
      # aarch64: invalid operating system or processor architecture
      "TestCanIUpgradeToE0"

      # aarch64: thumbnail previews are nondeterministic
      "TestUploadFiles/multipart_Happy_image_thumbnail"
      "TestUploadFiles/simple_Happy_image_thumbnail"
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

      # Waits for MySQL to come up or down.
      wait_mysql() {
        wait_cmd mysql "$1" mysqladmin ping
      }

      # Waits for Postgres to come up or down.
      wait_postgres() {
        wait_cmd postgres "$1" pg_isready -h localhost
      }

      # Waits for Redis to come up or down.
      wait_redis() {
        wait_cmd redis "$1" redis-cli ping
      }

      # Starts MySQL.
      start_mysql() {
        echo "Starting MySQL at $MYSQL_HOME" >&2
        mysqld &
        mysql_pid=$!
        echo "... PID $mysql_pid" >&2
        wait_mysql up
      }

      # Stops MySQL.
      stop_mysql() {
        if [ "$mysql_pid" -gt 0 ]; then
          echo "Terminating MySQL at $MYSQL_HOME (PID $mysql_pid)" >&2
          mysqladmin --host=127.0.0.1 --user=root --password=mostest --wait-for-all-slaves --shutdown-timeout=30 shutdown
          wait_mysql down
          wait_cmd 'mysql pid' down kill -0 "$mysql_pid"

          # Make sure the worker PID went down too (but it may be already gone).
          local worker_pid="$(<"$MYSQL_HOME"/mysqld.pid || echo 0)"
          if [ -n "$worker_pid" ] && [ $worker_pid -gt 0 ]; then
            wait_cmd 'mysql workers' down kill -0 "$worker_pid"
          fi

          mysql_pid=0
        fi
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

      # Configure MySQL.
      export MYSQL_HOME="$NIX_BUILD_TOP/.mysql"
      mkdir -p "$MYSQL_HOME"
      cat <<EOF >"$MYSQL_HOME/my.cnf"
      [client]
      port = 3306
      default-character-set = utf8mb4
      socket = $MYSQL_HOME/mysqld.sock

      [mysqld]
      skip-host-cache
      skip-name-resolve
      basedir = ${mariadb}
      datadir = $MYSQL_HOME/
      pid-file = $MYSQL_HOME/mysqld.pid
      socket = $MYSQL_HOME/mysqld.sock
      port = 3306
      explicit_defaults_for_timestamp
      collation-server = utf8mb4_general_ci
      init-connect = 'SET NAMES utf8mb4'
      character-set-server = utf8mb4
      EOF

      # Start MySQL.
      mysql_install_db --skip-name-resolve --auth-root-authentication-method=normal
      start_mysql

      # Init MySQL.
      cat <<EOF | mysql --defaults-file="$MYSQL_HOME/my.cnf" -u root -v
      -- This is the admin password for tests; see the docker-compose:
      -- https://github.com/mattermost/mattermost/blob/v${final.version}/server/docker-compose.yaml
      create user if not exists 'mmuser' identified by 'mostest';
      create database if not exists mattermost_test;
      grant all privileges on *.* to 'mmuser' with grant option;

      -- Also need to set up root (tests seem to override the user to root)
      alter user 'root'@'127.0.0.1' identified by 'mostest';

      flush privileges;
      show grants for 'root'@'127.0.0.1';
      show grants for 'mmuser';
      EOF

      # Need to change this so we use 127.0.0.1 in tests.
      export TEST_DATABASE_MYSQL_DSN='root:mostest@tcp(127.0.0.1:3306)/mattermost_test?charset=utf8mb4&readTimeout=30s&writeTimeout=30s'

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
      export GOFLAGS=" -parallel=$NIX_BUILD_CORES -skip='$(echo "$disabledTests" | tr ' ' '|')' "

      # ce n'est pas un conteneur
      MMCTL_TESTFLAGS="$GOFLAGS" MM_NO_DOCKER=true make $checkTargets

      runHook postCheck
    '';

    postCheck = ''
      # Clean up MySQL.
      if [ -d "$MYSQL_HOME" ]; then
        stop_mysql
        rm -rf "$MYSQL_HOME"
      fi

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
