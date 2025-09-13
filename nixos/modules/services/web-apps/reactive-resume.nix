{
  config,
  lib,
  options,
  pkgs,
  ...
}:
{
  options.services.reactive-resume = {
    enable = lib.mkEnableOption "Reactive Resume";

    package = lib.mkPackageOption pkgs "reactive-resume" { };

    port = lib.mkOption {
      type = lib.types.port;
      default = 3000;
      description = "TCP port number where the service will be available.";
    };
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open {option}`services.reactive-resume.port` in the firewall.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "reactive-resume";
      description = "User under which the service should run. Also used for the DB username and database name.";
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = "reactive-resume";
      description = "User under which the service should run.";
    };

    storageBucket = lib.mkOption {
      type = lib.types.str;
      default = "reactive-resume";
      description = "Bucket name";
    };

    chromeUrl = lib.mkOption {
      type = lib.types.str;
      description = "Chrome WebSocket URL";
    };

    secretsFile = lib.mkOption {
      type = lib.types.path;
      description = ''
        File containing secrets necessary to run this service. This requires at a minimum:

        ```
        # Authentication
        ACCESS_TOKEN_SECRET='my access token secret'
        REFRESH_TOKEN_SECRET='my refresh token secret'

        # Chrome
        CHROME_TOKEN='my Chrome token'

        # Storage
        STORAGE_ACCESS_KEY='my storage access key'
        STORAGE_SECRET_KEY='my storage secret key'
        ```
      '';
      example = "/run/secrets/reactive-resume";
    };

    extraConfig = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = ''
        Additional configuration values;
        see [upstream example](https://github.com/AmruthPillai/Reactive-Resume/blob/master/.env.example).
      '';
      example = lib.literalExpression ''
        {
          MAIL_FROM = "noreply@localhost";
        }
      '';
    };
  };

  config =
    let
      cfg = config.services.reactive-resume;
      databaseName = cfg.user;
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];

      networking.firewall = lib.mkIf cfg.openFirewall {
        allowedTCPPorts = [ cfg.port ];
      };

      services = {
        postgresql = {
          enable = true;
          ensureUsers = [
            {
              name = databaseName;
              ensureDBOwnership = true;
            }
          ];
          ensureDatabases = [ databaseName ];
        };
      };

      systemd.services.reactive-resume = {
        description = "Reactive Resume server";
        enable = true;
        environment =
          let
            minioCfg = config.services.minio;
            minioListenAddressHostAndPort = lib.strings.splitString ":" minioCfg.listenAddress;
          in
          assert (lib.lists.length minioListenAddressHostAndPort) == 2;
          let
            storageHost =
              let
                address = builtins.elemAt minioListenAddressHostAndPort 0;
              in
              if address == "" then "127.0.0.1" else address;
            storagePort = builtins.elemAt minioListenAddressHostAndPort 1;
          in
          {
            # Environment
            NODE_ENV = "production";

            # Ports
            PORT = toString cfg.port;

            # URLs
            PUBLIC_URL = "http://127.0.0.1:${builtins.toString cfg.port}";
            STORAGE_URL = "http://${storageHost}:${storagePort}/${cfg.storageBucket}";

            # Database
            DATABASE_URL = "postgresql://${cfg.user}@localhost:5432/${databaseName}?schema=public";

            # Chrome Browser (for printing)
            CHROME_URL = cfg.chromeUrl;

            # Storage
            STORAGE_ENDPOINT = storageHost;
            STORAGE_PORT = storagePort;
            STORAGE_BUCKET = cfg.storageBucket;
          }
          // cfg.extraConfig;
        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.nodejs} ${cfg.package}/apps/server/main";
          EnvironmentFile = cfg.secretsFile;
          User = cfg.user;
          Group = cfg.group;
          Restart = "always";
          # Hardening options
          AmbientCapabilities = [ ];
          CapabilityBoundingSet = [ ];
          LockPersonality = true;
          NoNewPrivileges = true;
          PrivateTmp = true;
          ProtectControlGroups = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectSystem = "strict";
          RestartSec = 5;
          RestrictNamespaces = true;
          RestrictSUIDSGID = true;
          UMask = "0007";
          WorkingDirectory = cfg.package;
        };
        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
      };
      users = {
        groups.${cfg.group} = { };
        users.${cfg.user} = {
          isSystemUser = true;
          inherit (cfg) group;
        };
      };
    };

  meta.maintainers = with lib.maintainers; [ l0b0 ];
}
