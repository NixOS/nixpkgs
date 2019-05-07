{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.security.rngd;
in
{
  options = {
    security.rngd = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable the rng daemon, which adds entropy from
          hardware sources of randomness to the kernel entropy pool when
          available.
        '';
      };
      debug = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable debug output (-d).";
      };
    };
  };

  config = mkIf cfg.enable {
    services.udev.extraRules = ''
      KERNEL=="random", TAG+="systemd"
      SUBSYSTEM=="cpu", ENV{MODALIAS}=="cpu:type:x86,*feature:*009E*", TAG+="systemd", ENV{SYSTEMD_WANTS}+="rngd.service"
      KERNEL=="hw_random", TAG+="systemd", ENV{SYSTEMD_WANTS}+="rngd.service"
    '';

    systemd.services.rngd = {
      bindsTo = [ "dev-random.device" ];

      after = [ "dev-random.device" ];

      description = "Hardware RNG Entropy Gatherer Daemon";

      serviceConfig = {
        ExecStart = "${pkgs.rng-tools}/sbin/rngd -f"
          + optionalString cfg.debug " -d";
      };
    };
  };
}
