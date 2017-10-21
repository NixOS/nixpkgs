{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.brltty;

in {

  options = {

    services.brltty.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the BRLTTY daemon.";
    };

  };

  config = mkIf cfg.enable {

    systemd.services.brltty = {
      description = "Braille Device Support";
      unitConfig = {
        Documentation = "http://mielke.cc/brltty/";
        DefaultDependencies = "no";
        RequiresMountsFor = "${pkgs.brltty}/var/lib/brltty";
      };
      serviceConfig = {
        ExecStart = "${pkgs.brltty}/bin/brltty --no-daemon";
        Type = "notify";
        TimeoutStartSec = 5;
        TimeoutStopSec = 10;
        Restart = "always";
        RestartSec = 30;
        Nice = -10;
        OOMScoreAdjust = -900;
        ProtectHome = "read-only";
        ProtectSystem = "full";
        SystemCallArchitectures = "native";
      };
      wants = [ "systemd-udev-settle.service" ];
      after = [ "local-fs.target" "systemd-udev-settle.service" ];
      before = [ "sysinit.target" ];
      wantedBy = [ "sysinit.target" ];
    };

  };

}
