{ config, lib, ... }:

let
  cfg = config.nix.optimise;
in

{
  options = {
    nix.optimise = {
      automatic = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Automatically run the nix store optimiser at a specific time.";
      };

      dates = lib.mkOption {
        default = [ "03:45" ];
        type = with lib.types; listOf str;
        description = ''
          Specification (in the format described by
          {manpage}`systemd.time(7)`) of the time at
          which the optimiser will run.
        '';
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.automatic -> config.nix.enable;
        message = ''nix.optimise.automatic requires nix.enable'';
      }
    ];

    systemd = lib.mkIf config.nix.enable {
      services.nix-optimise = {
        description = "Nix Store Optimiser";
        # No point this if the nix daemon (and thus the nix store) is outside
        unitConfig.ConditionPathIsReadWrite = "/nix/var/nix/daemon-socket";
        serviceConfig.ExecStart = "${config.nix.package}/bin/nix-store --optimise";
        startAt = lib.optionals cfg.automatic cfg.dates;
      };

      timers.nix-optimise = lib.mkIf cfg.automatic {
        timerConfig = {
          Persistent = true;
          RandomizedDelaySec = 1800;
        };
      };
    };
  };
}
