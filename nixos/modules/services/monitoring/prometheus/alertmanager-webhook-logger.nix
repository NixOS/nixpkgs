{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.prometheus.alertmanagerWebhookLogger;
in
{
  options.services.prometheus.alertmanagerWebhookLogger = {
    enable = mkEnableOption "Alertmanager Webhook Logger";

    package = mkPackageOption pkgs "alertmanager-webhook-logger" { };

    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Extra command line options to pass to alertmanager-webhook-logger.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.alertmanager-webhook-logger = {
      description = "Alertmanager Webhook Logger";

      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        ExecStart = ''
          ${cfg.package}/bin/alertmanager-webhook-logger \
          ${escapeShellArgs cfg.extraFlags}
        '';

        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [ "" ];
        DynamicUser = true;
        NoNewPrivileges = true;

        MemoryDenyWriteExecute = true;

        LockPersonality = true;

        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ProtectHome = "tmpfs";

        PrivateTmp = true;
        PrivateDevices = true;
        PrivateIPC = true;

        ProcSubset = "pid";

        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;

        Restart  = "on-failure";

        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;

        SystemCallFilter = [
          "@system-service"
          "~@cpu-emulation"
          "~@privileged"
          "~@reboot"
          "~@setuid"
          "~@swap"
        ];
      };
    };
  };

  meta.maintainers = [ maintainers.jpds ];
}
