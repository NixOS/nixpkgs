{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.esphome-device-builder;

  stateDir = "/var/lib/esphome-device-builder";
in
{
  meta.maintainers = with lib.maintainers; [ DavidvtWout ];

  options.services.esphome-device-builder = with lib; {
    enable = mkEnableOption "esphome device builder dashboard";

    package = mkPackageOption pkgs "esphome-device-builder" { };

    esphome-package = mkPackageOption pkgs "esphome" { };

    address = mkOption {
      type = types.str;
      default = "localhost";
      description = "esphome device builder dashboard address";
    };

    port = mkOption {
      type = types.port;
      default = 6052;
      description = "esphome device builder dashboard port";
    };

    openFirewall = mkOption {
      default = false;
      type = types.bool;
      description = "Whether to open the firewall for the specified port.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];

    users.users.esphome-device-builder = {
      isSystemUser = true;
      home = stateDir;
      createHome = true;
      group = "esphome-device-builder";
    };

    users.groups.esphome-device-builder = { };

    systemd.services.esphome-device-builder = {
      description = "ESPHome device builder dashboard";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [
        cfg.package
        cfg.esphome-package
      ];

      environment.PYTHONPATH = cfg.package.pythonPath;

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/esphome-device-builder --host ${cfg.address} --port ${toString cfg.port}";
        User = "esphome-device-builder";
        Group = "esphome-device-builder";
        WorkingDirectory = stateDir;
        Restart = "on-failure";
        ReadWritePaths = [ stateDir ];
        ExecPaths = [ stateDir ];

        # Hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        DevicePolicy = "closed";
        SupplementaryGroups = [ "dialout" ];
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = false; # breaks bwrap
        ProtectKernelLogs = false; # breaks bwrap
        ProtectKernelModules = true;
        ProtectKernelTunables = false; # breaks bwrap
        ProtectProc = "invisible";
        ProcSubset = "all"; # Using "pid" breaks bwrap
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
          "AF_UNIX"
        ];
        RestrictNamespaces = false; # Required by platformio for chroot
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "@mount" # Required by platformio for chroot
        ];
        UMask = "0077";
      };
    };
  };
}
