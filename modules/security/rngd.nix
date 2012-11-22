{ config, pkgs, ... }:

with pkgs.lib;

{
  options = {
    security.rngd.enable = mkOption {
      default = true;
      description = ''
        Whether to enable the rng daemon, which adds entropy from
        hardware sources of randomness to the kernel entropy pool when
        available. It is strongly recommended to keep this enabled!
      '';
    };
  };

  config = mkIf config.security.rngd.enable {
    boot.systemd.services.rngd = {
      wantedBy = [ "multi-user.target" ];

      description = "Hardware RNG Entropy Gatherer Daemon";

      serviceConfig.ExecStart = "${pkgs.rng_tools}/sbin/rngd -f";
    };
  };
}
