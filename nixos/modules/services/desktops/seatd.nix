{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.seatd;
  inherit (lib) mkEnableOption mkOption types;
in
{
  meta.maintainers = with lib.maintainers; [ sinanmohd ];

  options.services.seatd = {
    enable = mkEnableOption "seatd";

    user = mkOption {
      type = types.str;
      default = "root";
      description = "User to own the seatd socket";
    };
    group = mkOption {
      type = types.str;
      default = "seat";
      description = "Group to own the seatd socket";
    };
    logLevel = mkOption {
      type = types.enum [
        "debug"
        "info"
        "error"
        "silent"
      ];
      default = "info";
      description = "Logging verbosity";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      seatd
    ];
    users.groups.seat = lib.mkIf (cfg.group == "seat") { };

    systemd.services.seatd = {
      description = "Seat management daemon";
      documentation = [ "man:seatd(1)" ];

      wantedBy = [ "multi-user.target" ];
      restartIfChanged = false;

      serviceConfig = {
        Type = "notify";
        NotifyAccess = "all";
        SyslogIdentifier = "seatd";
        ExecStart = "${lib.getExe' pkgs.s6 "s6-notify-socket-from-fd"} ${pkgs.seatd.bin}/bin/seatd -n 1 -u ${cfg.user} -g ${cfg.group} -l ${cfg.logLevel}";
        Restart = "always";
        RestartSec = 1;

        # Filesystem lockdown
        ProtectHome = true;
        ProtectSystem = "strict";
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        PrivateTmp = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        UMask = "0077";

        # Privilege escalation
        NoNewPrivileges = true;
        RestrictSUIDSGID = true;

        # Network
        PrivateNetwork = true;
        IPAddressDeny = "any";

        # System call interfaces
        SystemCallFilter = [
          "@system-service"
          "~@resources"
        ];
        SystemCallErrorNumber = "EPERM";
        SystemCallArchitectures = "native";

        # Kernel
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        LockPersonality = true;

        # Namespaces
        RestrictNamespaces = true;

        # Service capabilities
        CapabilityBoundingSet = "CAP_SYS_ADMIN CAP_CHOWN CAP_SYS_TTY_CONFIG CAP_DAC_OVERRIDE";
        RestrictAddressFamilies = "AF_UNIX";
        RestrictRealtime = true;
        MemoryDenyWriteExecute = true;
        ProtectClock = true;
        ProtectHostname = true;

        # Devices
        DevicePolicy = "strict";
        DeviceAllow = [
          "char-/dev/console rw"
          "char-drm rw"
          "char-input rw"
          "char-tty rw"
          "/dev/null rw"
        ];
      };
    };
  };
}
