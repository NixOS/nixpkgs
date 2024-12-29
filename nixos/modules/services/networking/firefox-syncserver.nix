{ config, pkgs, lib, options, ... }:

let
  cfg = config.services.firefox-syncserver;
  opt = options.services.firefox-syncserver;
  defaultDatabase = "firefox_syncserver";
  defaultUser = "firefox-syncserver";

  dbIsLocal = cfg.database.host == "localhost";
  dbURL = "mysql://${cfg.database.user}@${cfg.database.host}/${cfg.database.name}";

  format = pkgs.formats.toml {};
  settings = {
    human_logs = true;
    syncstorage = {
      database_url = dbURL;
    };
    tokenserver = {
      node_type = "mysql";
      database_url = dbURL;
      fxa_email_domain = "api.accounts.firefox.com";
      fxa_oauth_server_url = "https://oauth.accounts.firefox.com/v1";
      run_migrations = true;
      # if JWK caching is not enabled the token server must verify tokens
      # using the fxa api, on a thread pool with a static size.
      additional_blocking_threads_for_fxa_requests = 10;
    } // lib.optionalAttrs cfg.singleNode.enable {
      # Single-node mode is likely to be used on small instances with little
      # capacity. The default value (0.1) can only ever release capacity when
      # accounts are removed if the total capacity is 10 or larger to begin
      # with.
      # https://github.com/mozilla-services/syncstorage-rs/issues/1313#issuecomment-1145293375
      node_capacity_release_rate = 1;
    };
  };
  configFile = format.generate "syncstorage.toml" (lib.recursiveUpdate settings cfg.settings);
  setupScript = pkgs.writeShellScript "firefox-syncserver-setup" ''
        set -euo pipefail
        shopt -s inherit_errexit

        schema_configured() {
          mysql ${cfg.database.name} -Ne 'SHOW TABLES' | grep -q services
        }

        update_config() {
          mysql ${cfg.database.name} <<"EOF"
            BEGIN;

            INSERT INTO `services` (`id`, `service`, `pattern`)
              VALUES (1, 'sync-1.5', '{node}/1.5/{uid}')
              ON DUPLICATE KEY UPDATE service='sync-1.5', pattern='{node}/1.5/{uid}';
            INSERT INTO `nodes` (`id`, `service`, `node`, `available`, `current_load`,
                                 `capacity`, `downed`, `backoff`)
              VALUES (1, 1, '${cfg.singleNode.url}', ${toString cfg.singleNode.capacity},
              0, ${toString cfg.singleNode.capacity}, 0, 0)
              ON DUPLICATE KEY UPDATE node = '${cfg.singleNode.url}', capacity=${toString cfg.singleNode.capacity};

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
          INSERT INTO `services` (`id`, `service`, `pattern`) VALUES ('1', 'sync-1.5', '{node}/1.5/{uid}');
          INSERT INTO `nodes` (`id`, `service`, `node`, `available`, `current_load`,
              `capacity`, `downed`, `backoff`)
            VALUES ('1', '1', 'https://mydomain.tld', '1', '0', '10', '0', '0');
        ```

        {option}`${opt.singleNode.enable}` does this automatically when enabled
      '';

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.syncstorage-rs;
        defaultText = lib.literalExpression "pkgs.syncstorage-rs";
        description = ''
          Package to use.
        '';
      };

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
    services.mysql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [{
        name = cfg.database.user;
        ensurePermissions = {
          "${cfg.database.name}.*" = "all privileges";
        };
      }];
    };

    systemd.services.firefox-syncserver = {
      wantedBy = [ "multi-user.target" ];
      requires = lib.mkIf dbIsLocal [ "mysql.service" ];
      after = lib.mkIf dbIsLocal [ "mysql.service" ];
      restartTriggers = lib.optional cfg.singleNode.enable setupScript;
      environment.RUST_LOG = cfg.logLevel;
      serviceConfig = {
        User = defaultUser;
        Group = defaultUser;
        ExecStart = "${cfg.package}/bin/syncserver --config ${configFile}";
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
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];
        RestrictRealtime = true;
        ProtectSystem = "strict";
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectHome = true;
        PrivateUsers = true;
        PrivateTmp = true;
        SystemCallFilter = [ "@system-service" "~ @privileged @resources" ];
        UMask = "0077";
      };
    };

    systemd.services.firefox-syncserver-setup = lib.mkIf cfg.singleNode.enable {
      wantedBy = [ "firefox-syncserver.service" ];
      requires = [ "firefox-syncserver.service" ] ++ lib.optional dbIsLocal "mysql.service";
      after = [ "firefox-syncserver.service" ] ++ lib.optional dbIsLocal "mysql.service";
      path = [ config.services.mysql.package ];
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
  };

  meta = {
    maintainers = [ ];
    doc = ./firefox-syncserver.md;
  };
}
