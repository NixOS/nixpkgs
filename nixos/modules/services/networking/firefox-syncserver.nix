{
  config,
  pkgs,
  lib,
  options,
  utils,
  ...
}:

let
  cfg = config.services.firefox-syncserver;
  opt = options.services.firefox-syncserver;
  defaultDatabase = "firefox_syncserver";
  defaultUser = "firefox-syncserver";

  # unfortunately the default for MySQL to have distinct database name and user names is not
  # compatible with NixOS PostgreSQL requiring the user and database name to be identical
  # to grant correct owner permissions
  dbName =
    if cfg.database.type == "pgsql" && cfg.database.name == defaultDatabase then
      defaultUser
    else
      cfg.database.name;

  # shorthand for deciding whether to use local UDS access
  dbIsLocal = cfg.database.host == "localhost";

  # escaped database URI
  dbURL =
    let
      dbHostEscaped =
        if lib.strings.match "[A-Za-z0-9]*:[A-Za-z0-9:%]+" cfg.database.host != null then # IPv6 address
          "[${cfg.database.host}]"
        # hostname, IPv4 address or path
        else
          lib.strings.escapeURL cfg.database.host;
      dbNameEscaped = lib.strings.escapeURL dbName;
      dbUserEscaped = lib.strings.escapeURL cfg.database.user;
    in
    if cfg.database.type == "mysql" then
      "mysql://${dbUserEscaped}@${dbHostEscaped}/${dbNameEscaped}${lib.optionalString dbIsLocal "?socket=/run/mysqld/mysqld.sock"}"
    else if cfg.database.type == "pgsql" then
      "postgres://${dbUserEscaped}@${dbHostEscaped}/${dbNameEscaped}${lib.optionalString dbIsLocal "?host=/run/postgresql"}"
    else
      throw "Unexpected database type: ${cfg.database.type}";

  format = pkgs.formats.toml { };
  settings = {
    human_logs = true;
    syncstorage = {
      node_type =
        if cfg.database.type == "mysql" then
          "mysql"
        else if cfg.database.type == "pgsql" then
          "postgres"
        else
          throw "Unexpected database type: ${cfg.database.type}";
      database_url = dbURL;
    };
    tokenserver = {
      node_type =
        if cfg.database.type == "mysql" then
          "mysql"
        else if cfg.database.type == "pgsql" then
          "postgres"
        else
          throw "Unexpected database type: ${cfg.database.type}";
      database_url = dbURL;
      fxa_email_domain = "api.accounts.firefox.com";
      fxa_oauth_server_url = "https://oauth.accounts.firefox.com/v1";
      run_migrations = true;
      # if JWK caching is not enabled the token server must verify tokens
      # using the fxa api, on a thread pool with a static size.
      additional_blocking_threads_for_fxa_requests = 10;
    }
    // lib.optionalAttrs cfg.singleNode.enable {
      # Single-node mode is likely to be used on small instances with little
      # capacity. The default value (0.1) can only ever release capacity when
      # accounts are removed if the total capacity is 10 or larger to begin
      # with.
      # https://github.com/mozilla-services/syncstorage-rs/issues/1313#issuecomment-1145293375
      node_capacity_release_rate = 1;
    };
  };
  configFile = format.generate "syncstorage.toml" (lib.recursiveUpdate settings cfg.settings);
  setupScript =
    with if cfg.database.type == "mysql" then
      {
        databaseExecCommand = "${config.services.mysql.package}/bin/mysql '${dbName}'";
        databaseListTables = "${config.services.mysql.package}/bin/mysql '${dbName}' -Ne 'SHOW TABLES'";
      }
      else if cfg.database.type == "pgsql" then
        {
          databaseExecCommand = "${pkgs.util-linux}/bin/runuser -u postgres -- ${config.services.postgresql.package}/bin/psql -d '${dbName}'";
          databaseListTables = "${pkgs.util-linux}/bin/runuser -u postgres -- ${config.services.postgresql.package}/bin/psql -d '${dbName}' -tc '\d'";
        }
      else
        throw "Unexpected database type: ${cfg.database.type}";
    pkgs.writeShellScript "firefox-syncserver-setup" ''
      set -euo pipefail
      shopt -s inherit_errexit

      schema_configured() {
        ${databaseListTables} | grep -q services
      }

      update_config() {
        # Please use only standard SQL here (no MySQL-isms!)
        ${databaseExecCommand} <<"EOF"
          BEGIN;

          INSERT INTO services (id, service, pattern)
            VALUES (1, 'sync-1.5', '{node}/1.5/{uid}')
            ON DUPLICATE KEY UPDATE service='sync-1.5', pattern='{node}/1.5/{uid}';
          INSERT INTO nodes (id, service, node, available, current_load,
                               capacity, downed, backoff)
            VALUES (1, 1, '${cfg.singleNode.url}', ${toString cfg.singleNode.capacity},
            0, ${toString cfg.singleNode.capacity}, 0, 0)
            ON DUPLICATE KEY UPDATE node='${cfg.singleNode.url}', capacity=${toString cfg.singleNode.capacity};

          COMMIT;
      EOF
      }

      for (( try = 0; try < 60; try++ )); do
        if ! schema_configured; then
          sleep 2
        else
          update_config
          exit 0
        fi
      done

      echo "Single-node setup failed"
      exit 1
    '';
in

{
  options = {
    services.firefox-syncserver = {
      enable = lib.mkEnableOption ''
        the Firefox Sync storage service.

        Out of the box this will not be very useful unless you also configure at least
        one service and one nodes by inserting them into the mysql database manually, e.g.
        by running

        ```
          INSERT INTO services (id, service, pattern) VALUES ('1', 'sync-1.5', '{node}/1.5/{uid}');
          INSERT INTO nodes (id, service, node, available, current_load,
              capacity, downed, backoff)
            VALUES ('1', '1', 'https://mydomain.tld', '1', '0', '10', '0', '0');
        ```

        {option}`${opt.singleNode.enable}` does this automatically when enabled
      '';

      package = lib.mkOption {
        type = lib.types.nullOr lib.types.package;
        description = ''
          Syncstorage server package.
        '';
        default = null;
        defaultText = lib.literalExpression ''
          if services.firefox-syncserver.database.type == "mysql" then
            pkgs.syncstorage-rs-mysql
          else
            pkgs.syncstorage-rs-pgsql
        '';
      };

      database.type = lib.mkOption (
        {
          type = lib.types.enum [
            "mysql"
            "pgsql"
          ];
          description = ''
            Database system to use for storage.
          '';
        }
        // lib.optionalAttrs (builtins.compareVersions config.system.stateVersion "26.05" < 0) {
          # before 26.05 mysql was the only supported backend and assumed by default
          default = "mysql";
        }
      );

      database.name = lib.mkOption {
        # the mysql module does not allow `-quoting without resorting to shell
        # escaping, so we restrict db names for forward compaitiblity should this
        # behavior ever change.
        type = lib.types.strMatching "[a-z_][a-z0-9_]*";
        default = defaultDatabase;
        description = ''
          Database to use for storage. Will be created automatically if it does not exist
          and `config.${opt.database.createLocally}` is set.
        '';
      };

      database.user = lib.mkOption {
        type = lib.types.str;
        default = defaultUser;
        description = ''
          Username for database connections.
        '';
      };

      database.host = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = ''
          Database host name. `localhost` is treated specially and inserts
          systemd dependencies, other hostnames or IP addresses of the local machine do not.
        '';
      };

      database.createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to create database and user on the local machine if they do not exist.
          This includes enabling unix domain socket authentication for the configured user.
        '';
      };

      logLevel = lib.mkOption {
        type = lib.types.str;
        default = "error";
        description = ''
          Log level to run with. This can be a simple log level like `error`
          or `trace`, or a more complicated logging expression.
        '';
      };

      secrets = lib.mkOption {
        type = lib.types.path;
        description = ''
          A file containing the various secrets. Should be in the format expected by systemd's
          `EnvironmentFile` directory. Two secrets are currently available:
          `SYNC_MASTER_SECRET` and
          `SYNC_TOKENSERVER__FXA_METRICS_HASH_SECRET`.
        '';
      };

      singleNode = {
        enable = lib.mkEnableOption "auto-configuration for a simple single-node setup";

        enableTLS = lib.mkEnableOption "automatic TLS setup";

        enableNginx = lib.mkEnableOption "nginx virtualhost definitions";

        hostname = lib.mkOption {
          type = lib.types.str;
          description = ''
            Host name to use for this service.
          '';
        };

        capacity = lib.mkOption {
          type = lib.types.ints.unsigned;
          default = 10;
          description = ''
            How many sync accounts are allowed on this server. Setting this value
            equal to or less than the number of currently active accounts will
            effectively deny service to accounts not yet registered here.
          '';
        };

        url = lib.mkOption {
          type = lib.types.str;
          default = "${if cfg.singleNode.enableTLS then "https" else "http"}://${cfg.singleNode.hostname}";
          defaultText = lib.literalExpression ''
            ''${if cfg.singleNode.enableTLS then "https" else "http"}://''${config.${opt.singleNode.hostname}}
          '';
          description = ''
            URL of the host. If you are not using the automatic webserver proxy setup you will have
            to change this setting or your sync server may not be functional.
          '';
        };
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = format.type;

          options = {
            port = lib.mkOption {
              type = lib.types.port;
              default = 5000;
              description = ''
                Port to bind to.
              '';
            };

            tokenserver.enabled = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                Whether to enable the token service as well.
              '';
            };
          };
        };
        default = { };
        description = ''
          Settings for the sync server. These take priority over values computed
          from NixOS options.

          See the example config in
          <https://github.com/mozilla-services/syncstorage-rs/blob/master/config/local.example.toml>
          and the doc comments on the `Settings` structs in
          <https://github.com/mozilla-services/syncstorage-rs/blob/master/syncstorage-settings/src/lib.rs>
          and
          <https://github.com/mozilla-services/syncstorage-rs/blob/master/tokenserver-settings/src/lib.rs>
          for available options.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.mysql =
      lib.mkIf (cfg.database.createLocally && dbIsLocal && cfg.database.type == "mysql")
        {
          enable = true;
          ensureDatabases = [ dbName ];
          ensureUsers = [
            {
              name = cfg.database.user;
              ensurePermissions = {
                "${dbName}.*" = "all privileges";
              };
            }
          ];
        };

    services.postgresql = lib.mkIf (dbIsLocal && cfg.database.type == "pgsql") {
      enable = true;
      ensureDatabases = lib.mkIf cfg.database.createLocally [ dbName ];
      ensureUsers = lib.mkIf cfg.database.createLocally [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
        }
      ];
    };

    systemd.services.firefox-syncserver = {
      wantedBy = [ "multi-user.target" ];
      requires = lib.mkIf dbIsLocal (
        if cfg.database.type == "mysql" then
          [ "mysql.service" ]
        else if cfg.database.type == "pgsql" then
          [ "postgresql.service" ]
        else
          throw "Unexpected database type: ${cfg.database.type}"
      );
      after = lib.mkIf dbIsLocal (
        if cfg.database.type == "mysql" then
          [ "mysql.service" ]
        else if cfg.database.type == "pgsql" then
          [ "postgresql.target" ]
        else
          throw "Unexpected database type: ${cfg.database.type}"
      );
      restartTriggers = lib.optional cfg.singleNode.enable setupScript;
      environment.RUST_LOG = cfg.logLevel;
      serviceConfig =
        let
          package =
            if cfg.package != null then
              cfg.package
            else if cfg.database.type == "mysql" then
              pkgs.syncstorage-rs-mysql
            else if cfg.database.type == "pgsql" then
              pkgs.syncstorage-rs-pgsql
            else
              throw "Unexpected database type: ${cfg.database.type}";
        in
        {
          User = defaultUser;
          Group = defaultUser;
          ExecStart = utils.escapeSystemdExecArgs [
            "${package}/bin/syncserver"
            "--config"
            configFile
          ];
          EnvironmentFile = lib.mkIf (cfg.secrets != null) "${cfg.secrets}";

          # hardening
          RemoveIPC = true;
          CapabilityBoundingSet = [ "" ];
          DynamicUser = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          ProtectClock = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          ProtectKernelModules = true;
          SystemCallArchitectures = "native";
          # syncstorage-rs uses python-cffi internally, and python-cffi does not
          # work with MemoryDenyWriteExecute=true
          MemoryDenyWriteExecute = false;
          RestrictNamespaces = true;
          RestrictSUIDSGID = true;
          ProtectHostname = true;
          LockPersonality = true;
          ProtectKernelTunables = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          RestrictRealtime = true;
          ProtectSystem = "strict";
          ProtectProc = "invisible";
          ProcSubset = "pid";
          ProtectHome = true;
          PrivateUsers = true;
          PrivateTmp = true;
          SystemCallFilter = [
            "@system-service"
            "~ @privileged @resources"
          ];
          UMask = "0077";
        };
    };

    systemd.services.firefox-syncserver-setup = lib.mkIf cfg.singleNode.enable {
      wantedBy = [ "firefox-syncserver.service" ];
      requires = [ "firefox-syncserver.service" ];
      after = [ "firefox-syncserver.service" ];
      serviceConfig.ExecStart = [ "${setupScript}" ];
    };

    services.nginx.virtualHosts = lib.mkIf cfg.singleNode.enableNginx {
      ${cfg.singleNode.hostname} = {
        enableACME = cfg.singleNode.enableTLS;
        forceSSL = cfg.singleNode.enableTLS;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString cfg.settings.port}";
          # We need to pass the Host header that matches the original Host header. Otherwise,
          # Hawk authentication will fail (because it assumes that the client and server see
          # the same value of the Host header).
          recommendedProxySettings = true;
        };
      };
    };

    assertions = [
      {
        assertion =
          !cfg.database.createLocally
          || !dbIsLocal
          || cfg.database.type != "pgsql"
          || cfg.database.user == dbName;
        message = "`services.firefox-syncserver.database.name` must match `services.firefox-syncserver.database.user` when creating local database";
      }
    ];
  };

  meta = {
    maintainers = [ ];
    doc = ./firefox-syncserver.md;
  };
}
