{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.fail2ban-dashboard;
in

{
  ###### interface

  options = {
    services.fail2ban-dashboard = {
      enable = lib.mkEnableOption "fail2ban-dashboard";

      package = lib.mkPackageOption pkgs "fail2ban-dashboard" { };

      port = lib.mkOption {
        type = lib.types.port;
        description = "The port to listen on";
        default = 3000; # This is not configurable right now: https://github.com/webishdev/fail2ban-dashboard/issues/1
        example = 3001;
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.fail2ban.enable;
        message = ''
          fail2ban-dashboard cannot function without fail2ban.
        '';
      }
    ];

    systemd.services.fail2ban-dashboard = {
      description = "fail2ban-dashboard";
      requires = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      after = lib.optionals config.services.fail2ban.enable [ "fail2ban.service" ];

      partOf = lib.optional config.networking.firewall.enable "firewall.service";

      serviceConfig = {
        Restart = "always";
        ExecStart = "${cfg.package}";

        DynamicUser = true;
        UMask = "0077";
        LockPersonality = true;
        LogsDirectory = "fail2ban-dashboard";
        LogsDirectoryMode = "0750";
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "noaccess";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RuntimeDirectory = "fail2ban-dashboard";
        RuntimeDirectoryMode = "0750";
        StateDirectory = "fail2ban-dashboard";
        StateDirectoryMode = "0750";
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    matthiasbeyer
  ];
}

