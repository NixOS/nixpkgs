{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.services.dump1090-fa;
  inherit (lib) mkOption types;
in
{
  options.services.dump1090-fa = {
    enable = lib.mkEnableOption "dump1090-fa";

    package = lib.mkPackageOption pkgs "dump1090-fa" { };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Additional passed arguments";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.dump1090-fa = {
      description = "dump1090 ADS-B receiver (FlightAware customization)";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = lib.escapeShellArgs (
          [
            (lib.getExe cfg.package)
            "--net"
            "--write-json"
            "%t/dump1090-fa"
          ]
          ++ cfg.extraArgs
        );
        DynamicUser = true;
        SupplementaryGroups = "plugdev";
        RuntimeDirectory = "dump1090-fa";
        WorkingDirectory = "%t/dump1090-fa";
        RuntimeDirectoryMode = 755;
        PrivateNetwork = true;
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectHome = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectSystem = "strict";
        ProtectHostname = true;
        RestrictSUIDSGID = true;
        RestrictNamespaces =
          "~"
          + (lib.concatStringsSep " " [
            "cgroup"
            "ipc"
            "net"
            "mnt"
            "pid"
            "user"
            "uts"
          ]);
        CapabilityBoundingSet = [
          "~CAP_AUDIT_CONTROL"
          "~CAP_AUDIT_READ"
          "~CAP_AUDIT_WRITE"
          "~CAP_KILL"
          "~CAP_MKNOD"
          "~CAP_NET_BIND_SERVICE"
          "~CAP_NET_BROADCAST"
          "~CAP_NET_ADMIN"
          "~CAP_NET_RAW"
          "~CAP_SYS_RAWIO"
          "~CAP_SYS_MODULE"
          "~CAP_SYS_PTRACE"
          "~CAP_SYS_TIME"
          "~CAP_SYS_NICE"
          "~CAP_SYS_RESOURCE"
          "~CAP_CHOWN"
          "~CAP_FSETID"
          "~CAP_SETUID"
          "~CAP_SETGID"
          "~CAP_SETPCAP"
          "~CAP_SETFCAP"
          "~CAP_DAC_OVERRIDE"
          "~CAP_DAC_READ_SEARCH"
          "~CAP_FOWNER"
          "~CAP_IPC_OWNER"
          "~CAP_IPC_LOCK"
          "~CAP_SYS_BOOT"
          "~CAP_SYS_ADMIN"
          "~CAP_MAC_ADMIN"
          "~CAP_MAC_OVERRIDE"
          "~CAP_SYS_CHROOT"
          "~CAP_BLOCK_SUSPEND"
          "~CAP_WAKE_ALARM"
          "~CAP_LEASE"
          "~CAP_SYS_PACCT"
        ];
        SystemCallFilter = [
          "~@clock"
          "~@debug"
          "~@module"
          "~@mount"
          "~@raw-io"
          "~@reboot"
          "~@swap"
          "~@privileged"
          "~@resources"
          "~@cpu-emulation"
          "~@obsolete"
        ];
        RestrictAddressFamilies = [ "~AF_PACKET" ];
        ProtectControlGroups = true;
        UMask = "0022";
        SystemCallArchitectures = "native";
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ aciceri ];
    doc = ./dump1090-fa.md;
  };
}
