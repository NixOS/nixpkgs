{ config, lib, ... }:

<<<<<<< HEAD
=======
with lib;

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
let
  cfg = config.nix.optimise;
in

{
<<<<<<< HEAD
  options = {
    nix.optimise = {
      automatic = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = lib.mdDoc "Automatically run the nix store optimiser at a specific time.";
      };

      dates = lib.mkOption {
        default = ["03:45"];
        type = with lib.types; listOf str;
=======

  ###### interface

  options = {

    nix.optimise = {

      automatic = mkOption {
        default = false;
        type = types.bool;
        description = lib.mdDoc "Automatically run the nix store optimiser at a specific time.";
      };

      dates = mkOption {
        default = ["03:45"];
        type = types.listOf types.str;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        description = lib.mdDoc ''
          Specification (in the format described by
          {manpage}`systemd.time(7)`) of the time at
          which the optimiser will run.
        '';
      };
    };
  };

<<<<<<< HEAD
=======

  ###### implementation

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  config = {
    assertions = [
      {
        assertion = cfg.automatic -> config.nix.enable;
        message = ''nix.optimise.automatic requires nix.enable'';
      }
    ];

<<<<<<< HEAD
    systemd = lib.mkIf config.nix.enable {
      services.nix-optimise = {
        description = "Nix Store Optimiser";
        # No point this if the nix daemon (and thus the nix store) is outside
        unitConfig.ConditionPathIsReadWrite = "/nix/var/nix/daemon-socket";
        serviceConfig.ExecStart = "${config.nix.package}/bin/nix-store --optimise";
        startAt = lib.optionals cfg.automatic cfg.dates;
      };

      timers.nix-optimise.timerConfig = {
        Persistent = true;
        RandomizedDelaySec = 1800;
      };
    };
  };
=======
    systemd.services.nix-optimise = lib.mkIf config.nix.enable
      { description = "Nix Store Optimiser";
        # No point this if the nix daemon (and thus the nix store) is outside
        unitConfig.ConditionPathIsReadWrite = "/nix/var/nix/daemon-socket";
        serviceConfig.ExecStart = "${config.nix.package}/bin/nix-store --optimise";
        startAt = optionals cfg.automatic cfg.dates;
      };

  };

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}
