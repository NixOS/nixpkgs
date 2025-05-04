{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    (lib.mkRemovedOptionModule [ "programs" "clash-verge" "tunMode" ] ''
      The tunMode will work with service mode which is enabled by default.
    '')
  ];
  options.programs.clash-verge = {
    enable = lib.mkEnableOption "Clash Verge";
    package = lib.mkOption {
      type = lib.types.package;
      description = ''
        The clash-verge package to use. Available options are
        clash-verge-rev and clash-nyanpasu, both are forks of
        the original clash-verge project.
      '';
      default = pkgs.clash-verge-rev;
      defaultText = lib.literalExpression "pkgs.clash-verge-rev";
    };
    autoStart = lib.mkEnableOption "Clash Verge auto launch";
  };

  config =
    let
      cfg = config.programs.clash-verge;
    in
    lib.mkIf cfg.enable {

      environment.systemPackages = [
        cfg.package
        (lib.mkIf cfg.autoStart (
          pkgs.makeAutostartItem {
            name = "clash-verge";
            package = cfg.package;
          }
        ))
      ];

      systemd.services.clash-verge = {
        enable = true;
        description = "Clash Verge Service Mode";
        serviceConfig = {
          ExecStart = "${cfg.package}/bin/clash-verge-service";
          Restart = "on-failure";
          ProtectSystem = "strict";
          NoNewPrivileges = true;
          ProtectHostname = true;
          ProtectProc = "invisible";
          ProcSubset = "pid";
          SystemCallArchitectures = "native";
          PrivateTmp = true;
          PrivateMounts = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          LockPersonality = true;
          RestrictRealtime = true;
          ProtectClock = true;
          MemoryDenyWriteExecute = true;
          RestrictSUIDSGID = true;
          RestrictNamespaces = [ "~user cgroup ipc mnt uts" ];
          RestrictAddressFamilies = [
            "AF_INET AF_INET6 AF_NETLINK AF_PACKET AF_RAW"
          ];
          CapabilityBoundingSet = [
            "CAP_NET_ADMIN CAP_NET_RAW CAP_SYS_ADMIN CAP_DAC_OVERRIDE CAP_SETUID CAP_SETGID CAP_CHOWN CAP_MKNOD"
          ];
          SystemCallFilter = [
            "~@aio @chown @clock @cpu-emulation @debug @keyring @memlock @module @mount @obsolete @pkey @privileged @raw-io @reboot @sandbox @setuid @swap @timer"
          ];
          SystemCallErrorNumber = "EPERM";
        };
        wantedBy = [ "multi-user.target" ];
      };
    };

  meta.maintainers = with lib.maintainers; [
    bot-wxt1221
    Guanran928
  ];
}
