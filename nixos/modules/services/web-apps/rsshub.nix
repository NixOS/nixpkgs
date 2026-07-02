{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.services.rsshub;
in
{
  options.services.rsshub = {
    enable = lib.mkEnableOption "RSSHub service";

    package = lib.mkPackageOption pkgs "rsshub" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for the specified port.";
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf lib.types.str;
        options = {
          LISTEN_INADDR_ANY = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Listen to any address";
            apply = x: if x then "1" else "0";
          };
          PORT = lib.mkOption {
            type = lib.types.port;
            default = 1200;
            description = "Listen on port.";
            apply = toString;
          };
          NO_LOGFILES = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Print logs into stderr.";
            apply = x: if x then "1" else "0";
          };
        };
      };
      default = { };
      example = lib.literalExpression ''
        {
          REQUEST_TIMEOUT = "3000";
          REQUEST_RETRY = "10";
          PUPPETEER_EXECUTABLE_PATH = lib.getExe pkgs.chromium";
        }
      '';
      description = ''
        Environment variables for RSSHub.
        See <https://docs.rsshub.app/deploy/config> for available options.
      '';
    };

    secretFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = lib.literalExpression ''
        [ config.sops.secrets.rsshub.path ]
      '';
      description = ''
        Environment variables stored in files for secrets.
        See <https://docs.rsshub.app/deploy/config> for available options.
      '';
    };

    redis = {
      enable = lib.mkEnableOption "Redis for RSSHub";
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Create and use a local Redis instance. Sets `services.redis.servers.rsshub`.";
      };
      host = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = "The Redis host.";
      };
      port = lib.mkOption {
        type = lib.types.port;
        default = 6379;
        description = "The Redis port.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.redis.servers.rsshub = lib.mkIf (cfg.redis.enable && cfg.redis.createLocally) {
      enable = true;
      port = cfg.redis.port;
    };

    services.rsshub.settings = lib.mkIf cfg.redis.enable {
      CACHE_TYPE = "redis";
      REDIS_URL = "redis://${cfg.redis.host}:${toString cfg.redis.port}";
    };

    systemd.services.rsshub = {
      description = "RSSHub - Everything is RSSible";
      wantedBy = [ "multi-user.target" ];
      after = lib.optional (cfg.redis.enable && cfg.redis.createLocally) "redis-rsshub.service";
      requires = lib.optional (cfg.redis.enable && cfg.redis.createLocally) "redis-rsshub.service";

      environment = cfg.settings;

      serviceConfig = {
        Type = "simple";
        User = "rsshub";
        Group = "rsshub";
        DynamicUser = true;
        StateDirectory = "rsshub";
        EnvironmentFile = cfg.secretFiles;
        ExecStart = lib.getExe cfg.package;
        Restart = "on-failure";
        RestartSec = "10s";

        # Hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ (lib.toInt cfg.settings.PORT) ];
  };

  meta.maintainers = with lib.maintainers; [ vonfry ];
}
