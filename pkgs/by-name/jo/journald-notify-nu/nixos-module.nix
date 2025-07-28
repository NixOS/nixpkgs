{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.journald-notify-nu;
in {
  options.services.journald-notify-nu = {
    enable = mkEnableOption "journald-notify-nu service for converting systemd journal entries to desktop notifications";

    package = mkPackageOption pkgs "journald-notify-nu" { };

    user = mkOption {
      type = types.str;
      default = "journald-notify";
      description = "User account under which journald-notify-nu runs.";
    };

    group = mkOption {
      type = types.str;
      default = "journald-notify";
      description = "Group under which journald-notify-nu runs.";
    };

    settings = mkOption {
      type = types.attrs;
      default = { };
      description = "Configuration for journald-notify-nu.";
      example = {
        filters = {
          priority = "warning";
          units = [ "sshd.service" "systemd-logind.service" ];
        };
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      group = cfg.group;
      isSystemUser = true;
      description = "journald-notify-nu service user";
    };

    users.groups.${cfg.group} = { };

    systemd.services.journald-notify-nu = {
      description = "Journal to desktop notification service";
      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-journald.service" ];
      requires = [ "systemd-journald.service" ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/journald-notify-nu";
        Restart = "always";
        RestartSec = 5;
        
        # Security settings
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RemoveIPC = true;
        
        # Journal access
        SupplementaryGroups = [ "systemd-journal" ];
      };

      environment = {
        # Pass configuration as environment variables if needed
      } // (optionalAttrs (cfg.settings != { }) {
        JOURNALD_NOTIFY_CONFIG = builtins.toJSON cfg.settings;
      });
    };
  };
}