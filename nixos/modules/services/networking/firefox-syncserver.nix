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
    database_url = dbURL;
    human_logs = true;
    tokenserver = {
      node_type = "mysql";
      database_url = dbURL;
      fxa_email_domain = "api.accounts.firefox.com";
      fxa_oauth_server_url = "https://oauth.accounts.firefox.com/v1";
      run_migrations = true;
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
in

{
  options = {
    services.firefox-syncserver = {
      enable = lib.mkEnableOption ''
        the Firefox Sync storage service.

        Out of the box this will not be very useful unless you also configure at least
        one service and one nodes by inserting them into the mysql database manually, e.g.
        by running

        <programlisting>
          INSERT INTO `services` (`id`, `service`, `pattern`) VALUES ('1', 'sync-1.5', '{node}/1.5/{uid}');
          INSERT INTO `nodes` (`id`, `service`, `node`, `available`, `current_load`,
              `capacity`, `downed`, `backoff`)
            VALUES ('1', '1', 'https://mydomain.tld', '1', '0', '10', '0', '0');
        </programlisting>

        <option>${opt.singleNode.enable}</option> does this automatically when enabled
      '';

      package = lib.mkOption {
        type = lib.types.package;
        default = pkgs.syncstorage-rs;
        defaultText = lib.literalExpression "pkgs.syncstorage-rs";
        description = lib.mdDoc ''
          Package to use.
        '';
      };

      database.name = lib.mkOption {
        # the mysql module does not allow `-quoting without resorting to shell
        # escaping, so we restrict db names for forward compaitiblity should this
        # behavior ever change.
        type = lib.types.strMatching "[a-z_][a-z0-9_]*";
        default = defaultDatabase;
        description = lib.mdDoc ''
          Database to use for storage. Will be created automatically if it does not exist
          and `config.${opt.database.createLocally}` is set.
        '';
      };

      database.user = lib.mkOption {
        type = lib.types.str;
        default = defaultUser;
        description = lib.mdDoc ''
          Username for database connections.
        '';
      };

      database.host = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = lib.mdDoc ''
          Database host name. `localhost` is treated specially and inserts
          systemd dependencies, other hostnames or IP addresses of the local machine do not.
        '';
      };

      database.createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether to create database and user on the local machine if they do not exist.
          This includes enabling unix domain socket authentication for the configured user.
        '';
      };

      logLevel = lib.mkOption {
        type = lib.types.str;
        default = "error";
        description = lib.mdDoc ''
          Log level to run with. This can be a simple log level like `error`
          or `trace`, or a more complicated logging expression.
        '';
      };

      secrets = lib.mkOption {
        type = lib.types.path;
        description = lib.mdDoc ''
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
          description = lib.mdDoc ''
            Host name to use for this service.
          '';
        };

        capacity = lib.mkOption {
          type = lib.types.ints.unsigned;
          default = 10;
          description = lib.mdDoc ''
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
          description = lib.mdDoc ''
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
              description = lib.mdDoc ''
                Port to bind to.
              '';
            };

            tokenserver.enabled = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = lib.mdDoc ''
                Whether to enable the token service as well.
              '';
            };
          };
        };
        default = { };
        description = lib.mdDoc ''
          Settings for the sync server. These take priority over values computed
          from NixOS options.

          See the doc comments on the `Settings` structs in
          <https://github.com/mozilla-services/syncstorage-rs/blob/master/syncstorage/src/settings.rs>
          and
          <https://github.com/mozilla-services/syncstorage-rs/blob/master/syncstorage/src/tokenserver/settings.rs>
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
      environment.RUST_LOG = cfg.logLevel;
      serviceConfig = {
        User = defaultUser;
        Group = defaultUser;
        ExecStart = "${cfg.package}/bin/syncstorage --config ${configFile}";
        Stderr = "journal";
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
      script = ''
        set -euo pipefail
        shopt -s inherit_errexit

        schema_configured() {
          mysql ${cfg.database.name} -Ne 'SHOW TABLES' | grep -q services
        }

        services_configured() {
          [ 1 != $(mysql ${cfg.database.name} -Ne 'SELECT COUNT(*) < 1 FROM `services`') ]
        }

        create_services() {
          mysql ${cfg.database.name} <<"EOF"
            BEGIN;

            INSERT INTO `services` (`id`, `service`, `pattern`)
              VALUES (1, 'sync-1.5', '{node}/1.5/{uid}');
            INSERT INTO `nodes` (`id`, `service`, `node`, `available`, `current_load`,
                                 `capacity`, `downed`, `backoff`)
              VALUES (1, 1, '${cfg.singleNode.url}', ${toString cfg.singleNode.capacity},
                      0, ${toString cfg.singleNode.capacity}, 0, 0);

            COMMIT;
        EOF
        }

        update_nodes() {
          mysql ${cfg.database.name} <<"EOF"
            UPDATE `nodes`
              SET `capacity` = ${toString cfg.singleNode.capacity}
              WHERE `id` = 1;
        EOF
        }

        for (( try = 0; try < 60; try++ )); do
          if ! schema_configured; then
            sleep 2
          elif services_configured; then
            update_nodes
            exit 0
          else
            create_services
            exit 0
          fi
        done

        echo "Single-node setup failed"
        exit 1
      '';
    };

    services.nginx.virtualHosts = lib.mkIf cfg.singleNode.enableNginx {
      ${cfg.singleNode.hostname} = {
        enableACME = cfg.singleNode.enableTLS;
        forceSSL = cfg.singleNode.enableTLS;
        locations."/" = {
          proxyPass = "http://localhost:${toString cfg.settings.port}";
          # source mentions that this header should be set
          extraConfig = ''
            add_header X-Content-Type-Options nosniff;
          '';
        };
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ pennae ];
    # Don't edit the docbook xml directly, edit the md and generate it:
    # `pandoc firefox-syncserver.md -t docbook --top-level-division=chapter --extract-media=media -f markdown+smart > firefox-syncserver.xml`
    doc = ./firefox-syncserver.xml;
  };
}
