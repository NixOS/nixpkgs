{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.zcfan;

  configText = lib.concatStrings (
    lib.mapAttrsToList (
      name: value: lib.concatMapStrings (item: "${name} ${toString item}\n") (lib.toList value)
    ) cfg.settings
  );
in
{
  options = {
    services.zcfan = {
      enable = lib.mkEnableOption "zero-configuration fan daemon for ThinkPads (zcfan)";

      settings = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.oneOf [
            lib.types.int
            lib.types.str
            (lib.types.listOf (
              lib.types.oneOf [
                lib.types.int
                lib.types.str
              ]
            ))
          ]
        );
        default = { };
        example = lib.literalExpression ''
          {
            max_temp = 85;
            med_temp = 70;
            low_temp = 55;
            temp_hysteresis = 20;
            ignore_sensor = [ "nvme" "BAT0" ];
          }
        '';
        description = ''
          Options written to {file}`/etc/zcfan.conf`. See
          {manpage}`zcfan(1)` and the
          [project readme](https://github.com/cdown/zcfan/tree/master?tab=readme-ov-file#usage)
          for the supported options.

          List values are written as repeated lines, which is needed for
          `ignore_sensor`.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.services.thinkfan.enable;
        message = ''
          You have set services.zcfan.enable = true;
          which conflicts with services.thinkfan.enable = true;
        '';
      }
    ];

    environment.systemPackages = [ pkgs.zcfan ];
    environment.etc."zcfan.conf".text = configText;

    systemd.services = {
      zcfan = {
        description = "Zero-configuration fan control for ThinkPad";
        wantedBy = [ "multi-user.target" ];
        conflicts = [ "thinkfan.service" ];
        restartTriggers = [ config.environment.etc."zcfan.conf".source ];
        serviceConfig = {
          ExecStart = lib.getExe pkgs.zcfan;
          Restart = "on-failure";
          RestartSec = "30s";
          TimeoutStopSec = 2;

          # Hardening
          CapabilityBoundingSet = [ "" ];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateNetwork = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHome = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectSystem = "strict";
          RestrictAddressFamilies = [ "none" ];
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          SystemCallArchitectures = [ "native" ];
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
            "~@resources"
          ];
          ReadWritePaths = [
            "-/proc/acpi/ibm/fan"
          ];
        };
      };

      zcfan-sleep = {
        description = "Notify zcfan of imminent sleep";
        before = [ "sleep.target" ];
        wantedBy = [ "sleep.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = [
            "-${lib.getExe' pkgs.procps "pkill"} -x -PWR zcfan"
            # The signal handler races with sleep, so delay a bit.
            "${lib.getExe' pkgs.coreutils "sleep"} 1"
          ];
        };
      };

      zcfan-resume = {
        description = "Reload zcfan after waking up from suspend";
        after = [
          "sysinit.target"
          "suspend.target"
          "suspend-then-hibernate.target"
          "hybrid-sleep.target"
          "hibernate.target"
        ];
        wantedBy = [ "sleep.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "-${lib.getExe' pkgs.procps "pkill"} -x -USR2 zcfan";
        };
      };
    };

    boot.extraModprobeConfig = "options thinkpad_acpi fan_control=1";
  };

  meta.maintainers = with lib.maintainers; [ surfaceflinger ];
}
