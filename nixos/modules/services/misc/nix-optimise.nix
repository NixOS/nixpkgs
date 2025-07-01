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
        apply = lib.toList;
        type = with lib.types; either singleLineStr (listOf str);
        description = ''
          Specification (in the format described by
          {manpage}`systemd.time(7)`) of the time at
          which the optimiser will run.
        '';
      };

      randomizedDelaySec = lib.mkOption {
        default = "1800";
        type = lib.types.singleLineStr;
        example = "45min";
        description = ''
          Add a randomized delay before the optimizer will run.
          The delay will be chosen between zero and this value.
          This value must be a time span in the format specified by
          {manpage}`systemd.time(7)`
        '';
      };

      persistent = lib.mkOption {
        default = true;
        type = lib.types.bool;
        example = false;
        description = ''
          Takes a boolean argument. If true, the time when the service
          unit was last triggered is stored on disk. When the timer is
          activated, the service unit is triggered immediately if it
          would have been triggered at least once during the time when
          the timer was inactive. Such triggering is nonetheless
          subject to the delay imposed by RandomizedDelaySec=. This is
          useful to catch up on missed runs of the service when the
          system was powered down.
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
        # do not start and delay when switching
        restartIfChanged = false;
      };

      timers.nix-optimise = lib.mkIf cfg.automatic {
        timerConfig = {
          RandomizedDelaySec = cfg.randomizedDelaySec;
          Persistent = cfg.persistent;
        };
      };
    };
  };
}
