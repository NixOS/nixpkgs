{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.sharkey;

  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "config.yml" cfg.settings;
in
{
  options.services.sharkey =
    let
      inherit (lib)
        mkEnableOption
        mkOption
        mkPackageOption
        types
        ;
    in
    {
      enable = mkEnableOption "Sharkey, a Sharkish microblogging platform";
      package = mkPackageOption pkgs "sharkey" { };

      environmentFiles = mkOption {
        type = types.listOf types.path;
        default = [ ];
        example = [ "/run/secrets/sharkey-env" ];
        description = ''
          List of paths to files containing environment variables for Sharkey to use at runtime.

          This is useful for keeping secrets out of the Nix store. See
          <https://docs.joinsharkey.org/docs/install/configuration/> for how to configure Sharkey using environment
          variables.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          Whether to open ports in the NixOS firewall for Sharkey.
        '';
      };

      setupMeilisearch = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = ''
          Whether to automatically set up a local Meilisearch instance and configure Sharkey to use it.

          You need to ensure `services.meilisearch.masterKeyFile` is correctly configured for a working
          Meilisearch setup. You also need to configure Sharkey to use an API key obtained from Meilisearch with the
          `MK_CONFIG_MEILISEARCH_APIKEY` environment variable, and set `services.sharkey.settings.meilisearch.index` to
          the created index. See <https://docs.joinsharkey.org/docs/customisation/search/meilisearch/> for how to create
          an API key and index.
        '';
      };

      setupPostgresql = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = ''
          Whether to automatically set up a local PostgreSQL database and configure Sharkey to use it.
        '';
      };

      setupRedis = mkOption {
        type = types.bool;
        default = true;
        example = false;
        description = ''
          Whether to automatically set up a local Redis cache and configure Sharkey to use it.
        '';
      };

      settings = mkOption {
        type = types.submodule {
          freeformType = settingsFormat.type;
          options = {
            url = mkOption {
              type = types.str;
              example = "https://blahaj.social/";
              description = ''
                The full URL that the Sharkey instance will be publically accessible on.

                Do NOT change this after initial setup!
              '';
            };

            port = mkOption {
              type = types.port;
              default = 3000;
              description = ''
                The port that Sharkey will listen on.
              '';
            };

            address = mkOption {
              type = types.str;
              default = "0.0.0.0";
              example = "127.0.0.1";
              description = ''
                The address that Sharkey binds to.
              '';
            };

            socket = mkOption {
              type = types.nullOr types.path;
              default = null;
              example = "/run/sharkey/sharkey.sock";
              description = ''
                If specified, creates a UNIX socket at the given path that Sharkey listens on.
              '';
            };

            mediaDirectory = mkOption {
              type = types.path;
              default = "/var/lib/sharkey";
              description = ''
                Path to the folder where Sharkey stores uploaded media such as images and attachments.
              '';
            };

            fulltextSearch.provider = mkOption {
              type = types.enum [
                "sqlLike"
                "sqlPgroonga"
                "sqlTsvector"
                "meilisearch"
              ];
              default = "sqlLike";
              example = "sqlPgroonga";
              description = ''
                Which provider to use for full text search.

                All options other than `sqlLike` require extra setup - see the comments in
                <https://activitypub.software/TransFem-org/Sharkey/-/blob/develop/.config/example.yml> for details.

                If `sqlPgroonga` is set, and `services.sharkey.setupPostgres` is `true`, the pgroonga extension will
                automatically be setup. You still need to create an index manually.

                If using Meilisearch, consider setting `services.sharkey.setupMeilisearch` instead, which will
                configure Meilisearch for you.
              '';
            };

            id = mkOption {
              type = types.enum [
                "aid"
                "aidx"
                "meid"
                "ulid"
                "objectid"
              ];
              default = "aidx";
              description = ''
                The ID generation method for Sharkey to use.

                Do NOT change this after initial setup!
              '';
            };
          };
        };
        default = { };
        description = ''
          Configuration options for Sharkey.

          See <https://activitypub.software/TransFem-org/Sharkey/-/blob/develop/.config/example.yml> for a list of all
          available configuration options.
        '';
      };
    };

  config =
    let
      inherit (lib) mkDefault mkIf mkMerge;
    in
    mkIf cfg.enable (mkMerge [
      {
        systemd.services.sharkey = {
          description = "Sharkey";
          documentation = [ "https://docs.joinsharkey.org/" ];
          wantedBy = [ "multi-user.target" ];
          startLimitBurst = 5;
          startLimitIntervalSec = 60;
          environment.MISSKEY_CONFIG_DIR = "/etc/sharkey";

          serviceConfig = {
            Type = "simple";
            ExecStart = "${lib.getExe cfg.package} migrateandstart";
            EnvironmentFile = cfg.environmentFiles;
            DynamicUser = true;
            TimeoutSec = 60;
            Restart = "always";
            SyslogIdentifier = "sharkey";
            ConfigurationDirectory = "sharkey";
            RuntimeDirectory = "sharkey";
            StateDirectory = "sharkey";
            CapabilityBoundingSet = "";
            LockPersonality = true;
            NoNewPrivileges = true;
            PrivateDevices = true;
            PrivateUsers = true;
            PrivateTmp = true;
            ProcSubset = "pid";
            ProtectClock = true;
            ProtectControlGroups = true;
            ProtectHome = true;
            ProtectHostname = true;
            ProtectKernelLogs = true;
            ProtectKernelModules = true;
            ProtectKernelTunables = true;
            ProtectProc = "invisible";
            ProtectSystem = "strict";
            ReadWritePaths = [ cfg.settings.mediaDirectory ];
            RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX AF_NETLINK";
            RestrictNamespaces = true;
            RestrictRealtime = true;
            SystemCallArchitectures = "native";
            SystemCallFilter = [
              "~@cpu-emulation @debug @mount @obsolete @privileged @resources"
              "@chown"
            ];
            UMask = "0077";
          };
        };

        environment.etc."sharkey/default.yml".source = configFile;
      }
      (mkIf cfg.openFirewall {
        networking.firewall.allowedTCPPorts = [ cfg.settings.port ];
      })
      (mkIf cfg.setupMeilisearch {
        services.meilisearch = {
          enable = mkDefault true;
          settings.env = mkDefault "production";
        };

        services.sharkey.settings = {
          fulltextSearch.provider = "meilisearch";
          meilisearch = {
            host = config.services.meilisearch.listenAddress;
            port = config.services.meilisearch.listenPort;
          };
        };

        systemd.services.sharkey = {
          after = [ "meilisearch.service" ];
          wants = [ "meilisearch.service" ];
        };
      })
      (mkIf cfg.setupPostgresql {
        services.postgresql = {
          enable = mkDefault true;
          ensureDatabases = [ "sharkey" ];
          ensureUsers = [
            {
              name = "sharkey";
              ensureDBOwnership = true;
            }
          ];

          extensions = mkIf (cfg.settings.fulltextSearch.provider == "sqlPgroonga") (ps: [ ps.pgroonga ]);
        };

        services.sharkey.settings.db = {
          host = "/run/postgresql";
          db = "sharkey";
        };

        systemd.services.sharkey = {
          after = [ "postgresql.target" ];
          bindsTo = [ "postgresql.target" ];
        };
      })
      (mkIf cfg.setupRedis {
        services.redis.servers.sharkey.enable = mkDefault true;

        services.sharkey.settings.redis.path = config.services.redis.servers.sharkey.unixSocket;

        systemd.services.sharkey = {
          after = [ "redis-sharkey.service" ];
          bindsTo = [ "redis-sharkey.service" ];

          serviceConfig.SupplementaryGroups = [
            config.services.redis.servers.sharkey.group
          ];
        };
      })
    ]);

  meta.maintainers = with lib.maintainers; [
    tmarkus
  ];
}
