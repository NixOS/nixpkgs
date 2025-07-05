{
  config,
  lib,
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
      description = "User under which the service should run.";
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = "reactive-resume";
      description = "User under which the service should run.";
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
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = [ cfg.package ];

      networking.firewall = lib.mkIf cfg.openFirewall {
        allowedTCPPorts = [ cfg.port ];
      };

      services.postgresql = {
        enable = true;
        ensureUsers = [
          {
            name = cfg.user;
            ensureDBOwnership = true;
          }
        ];
        ensureDatabases = [ cfg.user ];
      };

      systemd.services.reactive-resume = {
        description = "Reactive Resume server";
        enable = true;
        environment = {
          DATABASE_URL = "postgresql://${cfg.user}@localhost:5432/reactive-resume?schema=public";
          NODE_ENV = "production";
          PORT = toString cfg.port;
        };
        serviceConfig = {
          ExecStart = "${lib.getExe pkgs.pnpm} run start";
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
