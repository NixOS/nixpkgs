{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.kutt;

  settings = lib.attrsets.mapAttrs (name: value: toString value) (
    lib.mkMerge ([
      cfg.settings
      (lib.optionalAttrs cfg.configureRedis {
        REDIS_ENABLED = "true";
      })
      (lib.optionalAttrs cfg.configureNginx {
        TRUST_PROXY = "true";
      })
      (lib.optionalAttrs cfg.configurePostgres {
        DB_CLIENT = "pg";
        DB_HOST = "/run/postgresql";
        DB_NAME = cfg.user;
        DB_USER = cfg.user;
      })
    ])
  );

in
{
  options.services.kutt =
    let
      inherit (lib)
        mkEnableOption
        mkOption
        mkPackageOption
        types
        literalExpression
        ;
    in
    {
      enable = mkEnableOption "Kutt, a free modern URL shortener";

      package = mkPackageOption pkgs "kutt" { };
      nodePackage = mkOption {
        type = types.package;
        default = pkgs.nodejs_22;
        defaultText = literalExpression "pkgs.nodejs_24";
        description = "Node.js package to use.";
      };

      environmentFile = mkOption {
        type = types.path;
        default = null;
        description = "Environment file for configuration of Kutt. Add your JWT_SECRET here.";
      };

      environment = mkOption {
        type = with types; attrsOf types.str;
        default = { };
        description = "Environment variables for Kutt.";
      };

      user = mkOption {
        type = types.str;
        default = "kutt";
        description = "User account under which the Kutt service runs.";
      };

      group = mkOption {
        type = types.str;
        default = "kutt";
        description = "Group account under which the Kutt service runs.";
      };

      configureRedis = mkEnableOption "Whether to configure Kutt to use a local Redis server";
      configurePostgres = mkEnableOption "Whether to configure Kutt to use the the local postgresql server";
      configureNginx = mkEnableOption "Whether to configure Kutt to use nginx as reverse proxy";

      settings = mkOption {
        default = { };
        type =
          with types;
          (submodule {
            freeformType = attrsOf (oneOf [
              str
              int
              bool
            ]);
            options = {
              PORT = mkOption {
                type = port;
                default = 3000;
                description = "The port on which Kutt should listen";
              };
              SITE_NAME = mkOption {
                type = str;
                default = "Kutt";
                description = "The site name for the Kutt instance";
              };
              DEFAULT_DOMAIN = mkOption {
                type = str;
                default = "localhost:3000";
                description = "The domain that Kutt should use";
              };
              LINK_LENGTH = mkOption {
                type = int;
                default = 6;
                description = "The length for shortened links";
              };
            };
          });
        description = "Configuration for Kutt, see <https://github.com/thedevs-network/kutt?tab=readme-ov-file#configuration>";
      };
    };

  config = lib.mkIf cfg.enable {
    users.users.kutt = lib.mkIf (cfg.user == "kutt") {
      isSystemUser = true;
      group = cfg.group;
    };

    users.groups.kutt = lib.mkIf (cfg.group == "kutt") { };

    systemd.services.kutt = {
      description = "Kutt URL Shortener Service";
      after = [
        "network.target"
        "postgresql.service"
      ];
      wants = [ "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];

      preStart = "${cfg.package}/lib/node_modules/kutt/node_modules/.bin/knex migrate:latest";
      script = "${cfg.nodePackage}/bin/node server/server.js --production";

      environment = settings;

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = "${cfg.package}/lib/node_modules/kutt";
        EnvironmentFile = cfg.environmentFile;
        Restart = "always";

        # Hardening
        CapabilityBoundingSet = [ "" ];
        DevicePolicy = "closed";
        PrivateTmp = true;
        ProtectHome = true;
        ProtectSystem = "strict";
        MemoryDenyWriteExecute = "off";
        NoNewPrivileges = true;
        LockPersonality = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
      };
    };

    services.redis.servers.kutt = lib.mkIf cfg.configureRedis {
      enable = true;
      user = cfg.user;
    };

    services.postgresql = lib.mkIf cfg.configurePostgres {
      enable = true;
      ensureUsers = lib.singleton {
        name = cfg.user;
        ensureDBOwnership = true;
      };
      ensureDatabases = [ cfg.user ];
    };

    services.nginx.virtualHosts."${cfg.settings.DEFAULT_DOMAIN}" = lib.mkIf cfg.configureNginx {
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString cfg.settings.PORT}";
        recommendedProxySettings = true;
      };
    };
  };
}
