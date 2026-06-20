{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.geph;
in
{
  options.services.geph = {
    enable = lib.mkEnableOption "geph client daemon";

    package = lib.mkPackageOption pkgs "geph" { };

    configFile = lib.mkOption {
      type = lib.types.pathWith {
        inStore = false;
        absolute = true;
      };
      description = ''
        Path to the geph config file.

        This file contain sensitive credentials, so it must not live in the Nix store.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot.kernelModules = [ "tun" ];
    networking.firewall.checkReversePath = "loose";

    systemd.services.geph = {
      description = "geph client daemon";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      startLimitBurst = 5;
      startLimitIntervalSec = 20;
      serviceConfig = {
        DynamicUser = true;
        LoadCredential = "geph-config:${cfg.configFile}";
        ExecStart = "${lib.getExe cfg.package} --config %d/geph-config";

        Restart = "on-failure";
        RestartSec = 2;
        LimitNOFILE = 65535;

        StateDirectory = "geph";
        StateDirectoryMode = "0700";
        WorkingDirectory = "/var/lib/geph";

        AmbientCapabilities = [
          "CAP_NET_ADMIN"
          "CAP_NET_BIND_SERVICE"
        ];
        CapabilityBoundingSet = [
          "CAP_NET_ADMIN"
          "CAP_NET_BIND_SERVICE"
        ];
        DeviceAllow = "/dev/net/tun rw";
        DevicePolicy = "closed";
        PrivateUsers = false;
        PrivateDevices = false;
        RestrictAddressFamilies = [
          "AF_UNIX"
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateMounts = true;
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
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = "@system-service";
        UMask = "0077";
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [
      MCSeekeri
    ];
  };
}
