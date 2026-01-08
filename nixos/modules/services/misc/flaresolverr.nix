{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.flaresolverr;
in
{
  options = {
    services.flaresolverr = {
      enable = lib.mkEnableOption "FlareSolverr, a proxy server to bypass Cloudflare protection";

      package = lib.mkPackageOption pkgs "flaresolverr" { };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Open the port in the firewall for FlareSolverr.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8191;
        description = "The port on which FlareSolverr will listen for incoming HTTP traffic.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.flaresolverr = {
      description = "FlareSolverr";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        HOME = "/run/flaresolverr";
        PORT = toString cfg.port;
      };

      serviceConfig = {
        SyslogIdentifier = "flaresolverr";
        Restart = "always";
        RestartSec = 5;
        Type = "simple";
        DynamicUser = true;
        UMask = "0077";
        RuntimeDirectory = "flaresolverr";
        WorkingDirectory = "/run/flaresolverr";
        ExecStart = lib.getExe cfg.package;
        TimeoutStopSec = 30;

        # Systemd hardening
        LockPersonality = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictRealtime = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = [
          "net"
          "pid"
          "user"
        ];
        CapabilityBoundingSet = [
          "~CAP_BLOCK_SUSPEND"
          "~CAP_BPF"
          "~CAP_CHOWN"
          "~CAP_IPC_LOCK"
          "~CAP_MKNOD"
          "~CAP_NET_ADMIN"
          "~CAP_NET_RAW"
          "~CAP_PERFMON"
          "~CAP_SYSLOG"
          "~CAP_SYS_ADMIN"
          "~CAP_SYS_BOOT"
          "~CAP_SYS_MODULE"
          "~CAP_SYS_PACCT"
          "~CAP_SYS_PTRACE"
          "~CAP_SYS_TIME"
          "~CAP_WAKE_ALARM"
        ];
        SystemCallFilter = [
          "~@chown"
          "~@clock"
          "~@cpu-emulation"
          "~@debug"
          "~@keyring"
          "~@memlock"
          "~@module"
          "~@obsolete"
          "~@pkey"
          "~@raw-io"
          "~@reboot"
          "~@setuid"
          "~@swap"
          "~@timer"
        ];
        SystemCallErrorNumber = "EPERM";
        SystemCallArchitectures = "native";
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.port ]; };
  };
}
