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
        default = false;
        description = ''
          Whether to enable the rng daemon.  Devices that the kernel recognises
          as entropy sources are handled automatically by krngd.
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
