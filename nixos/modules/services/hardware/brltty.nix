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
        Type = "simple";        # Change to notidy after next releae
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
      before = [ "sysinit.target" ];
      wantedBy = [ "sysinit.target" ];
    };

  };

}
