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
    enable = lib.mkEnableOption "the Geph proxy client daemon";

    package = lib.mkPackageOption pkgs "geph" { };

    configFile = lib.mkOption {
      type = lib.types.pathWith {
        inStore = false;
        absolute = true;
      };
      description = ''
        Path to the `geph5-client` YAML configuration file, which selects the
        local SOCKS5/HTTP/PAC listeners and the broker to use.

        It contains account credentials, so it must not be in the Nix store.
      '';
    };

    manager = {
      enable = lib.mkEnableOption ''
        the privileged Geph manager. It is required by the Geph desktop
        application and by full-tunnel VPN mode, and configures the system
        proxy of logged-in users
      '';
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      systemd.services.geph = {
        description = "Geph proxy client";
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

          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
          CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
          PrivateDevices = true;
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
    })

    (lib.mkIf cfg.manager.enable {
      boot.kernelModules = [ "tun" ];

      users.groups.geph5-daemon = { };
      users.users.geph5-daemon = {
        isSystemUser = true;
        group = "geph5-daemon";
      };

      systemd.services.geph-manager = {
        description = "Geph privileged manager";
        wantedBy = [ "multi-user.target" ];
        wants = [ "network-online.target" ];
        after = [ "network-online.target" ];
        serviceConfig = {
          ExecStart = "${lib.getExe' cfg.package "geph5"} manager";

          Restart = "always";
          RestartSec = 2;
          LimitNOFILE = 65535;

          RuntimeDirectory = "geph";
          RuntimeDirectoryMode = "0755";
          StateDirectory = "geph-manager";
          StateDirectoryMode = "0755";
          BindPaths = [ "/var/lib/geph-manager:/var/lib/geph" ];

          UMask = "0077";

          CapabilityBoundingSet = [
            "CAP_CHOWN"
            "CAP_DAC_OVERRIDE"
            "CAP_KILL"
            "CAP_NET_ADMIN"
            "CAP_SETGID"
            "CAP_SETUID"
          ];
          DeviceAllow = [ "/dev/net/tun rw" ];
          DevicePolicy = "closed";
          PrivateDevices = false;
          PrivateUsers = false;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_NETLINK"
            "AF_UNIX"
          ];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateMounts = true;
          PrivateTmp = true;
          ProcSubset = "pid";
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "strict";
          ReadWritePaths = [ "/home" ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = "native";
          SystemCallFilter = "@system-service";
        };
      };
    })

    {
      warnings = lib.optional (cfg.enable && cfg.manager.enable) ''
        services.geph and services.geph.manager are both enabled. While a VPN
        tunnel is connected the manager listens on 127.0.0.1:9909 (SOCKS5),
        127.0.0.1:9910 (HTTP) and 127.0.0.1:12223 (PAC). If
        services.geph.configFile uses any of those ports, one of the two
        services will fail to bind.
      '';
    }
  ];

  meta = {
    maintainers = with lib.maintainers; [
      MCSeekeri
    ];
  };
}
