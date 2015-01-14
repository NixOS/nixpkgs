{ config, lib, pkgs, ... }:

with lib;

{
  options = {
    security.rngd.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to enable the rng daemon, which adds entropy from
        hardware sources of randomness to the kernel entropy pool when
        available.
      '';
    };
  };

  config = mkIf config.security.rngd.enable {
    services.udev.extraRules = ''
      KERNEL=="random", TAG+="systemd"
      SUBSYSTEM=="cpu", ENV{MODALIAS}=="x86cpu:*feature:*009E*", TAG+="systemd", ENV{SYSTEMD_WANTS}+="rngd.service"
      KERNEL=="hw_random", TAG+="systemd", ENV{SYSTEMD_WANTS}+="rngd.service"
      ${if config.services.tcsd.enable then "" else ''KERNEL=="tpm0", TAG+="systemd", ENV{SYSTEMD_WANTS}+="rngd.service"''}
    '';

    systemd.services.rngd = {
      bindsTo = [ "dev-random.device" ];

      after = [ "dev-random.device" ];

      description = "Hardware RNG Entropy Gatherer Daemon";

      serviceConfig.ExecStart = "${pkgs.rng_tools}/sbin/rngd -f -v" +
        (if config.services.tcsd.enable then " --no-tpm=1" else "");
    };
  };
}
