{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.tetrd;
in
{
  options.services.tetrd = {
    enable = lib.mkEnableOption "tetrd";
    package = lib.mkPackageOption pkgs "tetrd" { };
  };

  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ cfg.package ];
      # etc."resolv.conf".source = "/etc/tetrd/resolv.conf"; # Disabled overwriting of resolve.conf since otherwise tetrd disables your dns when its not connected to a device.
    };

    # Our resolv.conf will override resolvconf's version.
    networking.resolvconf.enable = false;

    systemd = {
      tmpfiles.rules = [ "f /etc/tetrd/resolv.conf - - -" ];

      services.tetrd = {
        description = cfg.package.meta.description;
        wantedBy = [ "multi-user.target" ];

        serviceConfig = {
          ExecStart = "${cfg.package}/opt/Tetrd/bin/tetrd";
          Restart = "always";
          RuntimeDirectory = "tetrd";
          RootDirectory = "/run/tetrd";
          DynamicUser = true;
          UMask = "006";
          DeviceAllow = "usb_device";
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateMounts = true;
          PrivateNetwork = lib.mkDefault false;
          PrivateTmp = true;
          PrivateUsers = lib.mkDefault false;
          ProtectClock = lib.mkDefault false;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          RemoveIPC = true;
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
          ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";

          SystemCallFilter = [
            "@system-service"
            "~@aio"
            "~@chown"
            "~@clock"
            "~@cpu-emulation"
            "~@debug"
            "~@keyring"
            "~@memlock"
            "~@module"
            "~@mount"
            "~@obsolete"
            "~@pkey"
            "~@raw-io"
            "~@reboot"
            "~@swap"
            "~@sync"
          ];

          BindReadOnlyPaths = [
            builtins.storeDir
            "/etc/ssl"
            "/etc/static/ssl"
            "${pkgs.net-tools}/bin/route:/usr/bin/route"
            "${pkgs.net-tools}/bin/ifconfig:/usr/bin/ifconfig"
          ];

          BindPaths = [
            "/etc/tetrd/resolv.conf:/etc/resolv.conf"
            "/run"
            "/var/log"
          ];

          CapabilityBoundingSet = [
            "CAP_DAC_OVERRIDE"
            "CAP_NET_ADMIN"
          ];

          AmbientCapabilities = [
            "CAP_DAC_OVERRIDE"
            "CAP_NET_ADMIN"
          ];
        };
      };
    };
  };
}
