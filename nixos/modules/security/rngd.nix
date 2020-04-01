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

      # Clean shutdown without DefaultDependencies
      conflicts = [ "shutdown.target" ];
      before = [
        "sysinit.target"
        "shutdown.target"
      ];

      description = "Hardware RNG Entropy Gatherer Daemon";

      # rngd may have to start early to avoid entropy starvation during boot with encrypted swap
      unitConfig.DefaultDependencies = false;
      serviceConfig = {
        ExecStart = "${pkgs.rng-tools}/sbin/rngd -f"
          + optionalString cfg.debug " -d";
        # PrivateTmp would introduce a circular dependency if /tmp is on tmpfs and swap is encrypted,
        # thus depending on rngd before swap, while swap depends on rngd to avoid entropy starvation.
        NoNewPrivileges = true;
        PrivateNetwork = true;
        ProtectSystem = "full";
        ProtectHome = true;
      };
    };
  };
}
