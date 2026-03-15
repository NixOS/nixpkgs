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

    user = lib.mkOption {
      type = lib.types.str;
      default = "rsshub";
      description = "User account under which RSSHub runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "rsshub";
      description = "Group under which RSSHub runs.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 1200;
      description = "Port on which RSSHub will listen.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for the specified port.";
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = lib.literalExpression ''
        {
          REQUEST_TIMEOUT = "3000";
          REQUEST_RETRY = "10";
        }
      '';
      description = ''
        Environment variables for RSSHub.
        See <https://docs.rsshub.app/deploy/config> for available options.
      '';
    };

    environmentFiles = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ ];
      example = lib.literalExpression ''
        [ config.sops.secrets.rsshub.path ]
      '';
      description = ''
        Environment variables stored in files for RSSHub.
        It can be used for secrets like agenix, sops-nix, etc.
        See <https://docs.rsshub.app/deploy/config> for available options.
      '';
    };

    redis = {
      enable = lib.mkEnableOption "Redis for RSSHub";
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = false;
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

    systemd.services.rsshub = {
      description = "RSSHub - Everything is RSSible";
      wantedBy = [ "multi-user.target" ];
      after = lib.optional (cfg.redis.enable && cfg.redis.createLocally) "redis-rsshub.service";
      requires = lib.optional (cfg.redis.enable && cfg.redis.createLocally) "redis-rsshub.service";

      environment = {
        # Manage logs in systemd.
        NO_LOGFILES = "1";
        PORT = toString cfg.port;
        # Disable listen any address by default.
        LISTEN_INADDR_ANY = "0";
      }
      // lib.optionalAttrs cfg.redis.enable {
        CACHE_TYPE = "redis";
        REDIS_URL = "redis://${cfg.redis.host}:${toString cfg.redis.port}";
      }
      // cfg.environment;

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        DynamicUser = true;
        DynamicGroup = true;
        StateDirectory = "rsshub";
        EnvironmentFile = cfg.environmentFiles;
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

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };

  meta.maintainers = with lib.maintainers; [ vonfry ];
}
