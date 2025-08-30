{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.orb;
in
{
  meta.maintainers = with lib.maintainers; [
    gepbird
  ];

  options.services.orb = {
    enable = lib.mkEnableOption "orb sensor";

    package = lib.mkPackageOption pkgs "orb" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.orb
    ];

    systemd.services.orb = {
      description = "Orb Sensor Service";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${lib.getExe cfg.package} sensor";
        StateDirectory = "orb";
        WorkingDirectory = "/var/lib/orb";

        AmbientCapabilities = [
          "CAP_NET_RAW"
        ];

        # TODO
        # Hardening
        #CapabilityBoundingSet = "";
        #DeviceAllow = "";
        #DevicePolicy = "closed";
        ##IPAddressDeny = "any"; # provides the service through network
        #LockPersonality = true;
        #MemoryDenyWriteExecute = true;
        #NoNewPrivileges = true;
        #PrivateDevices = true;
        #PrivateNetwork = false; # provides the service through network
        #PrivateTmp = true;
        #PrivateUsers = true;
        #ProcSubset = "pid";
        #ProtectClock = true;
        #ProtectControlGroups = true;
        #ProtectHome = true;
        #ProtectHostname = true;
        #ProtectKernelLogs = true;
        #ProtectKernelModules = true;
        #ProtectKernelTunables = true;
        #ProtectProc = "invisible";
        #ProtectSystem = "strict";
        #ReadWritePaths = [ cfg.dataDir ];
        #RemoveIPC = true;
        #RestrictAddressFamilies = [
        #  "AF_INET"
        #  "AF_INET6"
        #];
        #RestrictNamespaces = true;
        #RestrictRealtime = true;
        #RestrictSUIDSGID = true;
        #SystemCallArchitectures = "native";
        #SystemCallFilter = lib.concatStringsSep " " [
        #  "~"
        #  "@clock"
        #  "@cpu-emulation"
        #  "@debug"
        #  "@module"
        #  "@mount"
        #  "@obsolete"
        #  "@privileged"
        #  "@raw-io"
        #  "@reboot"
        #  "@resources"
        #  "@swap"
        #];
        #UMask = "0077";
      };
    };
  };
}
