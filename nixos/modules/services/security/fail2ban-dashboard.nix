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
  options = {
    services.fail2ban-dashboard = {
      enable = lib.mkEnableOption "fail2ban-dashboard";

      package = lib.mkPackageOption pkgs "fail2ban-dashboard" { };

      port = lib.mkOption {
        type = lib.types.port;
        description = "The port to listen on";
        default = 3000;
        example = 3001;
      };
    };
  };

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
      description = "Web dashboard for fail2ban";
      requires = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      after = [ "fail2ban.service" ];

      partOf = lib.optional config.networking.firewall.enable "firewall.service";

      serviceConfig = {
        Restart = "always";
        ExecStart =
          let
            args = lib.cli.toGNUCommandLineShell { } {
              port = cfg.port;
              cache-dir = "/var/cache/fail2ban-dashboard";
              socket = config.services.fail2ban.daemonSettings.Definition.socket;
            };
          in
          "${lib.getExe cfg.package} ${args}";

        DynamicUser = true;
        User = "fail2ban-dashboard";

        UMask = "0077";
        CacheDirectory = "fail2ban-dashboard";
        CacheDirectoryMode = "0700";

        LockPersonality = true;
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
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    matthiasbeyer
  ];
}
