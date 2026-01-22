{ config, lib, ... }:
let
  cfg = config.nix.optimise;
  inherit (lib)
    mkEnableOption
    mkRenamedOptionModule
    mkOption
    mkDefault
    mkMerge
    mkIf
    types
    ;
in
{
  imports = [
    (mkRenamedOptionModule [ "nix" "optimise" "automatic" ] [ "nix" "optimise" "enable" ])
  ];

  options.nix.optimise = {
    enable = mkEnableOption "" // {
      description = "Whether to enable the nix store optimiser.";
    };

    mode = mkOption {
      type = types.nullOr (
        types.enum [
          "async"
          "sync"
        ]
      );
      default = null;
      example = "async";
      description = ''
        The mode of operation for the nix store optimiser.
        `async` will run the optimiser at the specified time, and `sync` will run the optimiser after every rebuild.
        Important: `sync` mode sinificantly slows down rebuilds, so it is not recommended for most use cases.
        If `null`, the optimiser will not run automatically.
      '';
    };

    dates = mkOption {
      default = [ "03:45" ];
      apply = lib.toList;
      type = with types; either singleLineStr (listOf str);
      description = ''
        This is only available in `async` mode.

        Specification (in the format described by
        {manpage}`systemd.time(7)`) of the time at
        which the optimiser will run.
      '';
    };

    randomizedDelaySec = mkOption {
      default = "1800";
      type = types.singleLineStr;
      example = "45min";
      description = ''
        This is only available in `async` mode.

        Add a randomized delay before the optimizer will run.
        The delay will be chosen between zero and this value.
        This value must be a time span in the format specified by
        {manpage}`systemd.time(7)`
      '';
    };

    persistent = mkOption {
      default = true;
      type = types.bool;
      example = false;
      description = ''
        This is only available in `async` mode.

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

  config = mkIf cfg.enable (mkMerge [
    {
      assertions = [
        {
          assertion = cfg.enable -> config.nix.enable;
          message = ''`nix.optimise.enable` requires `nix.enable = true`'';
        }
        {
          assertion = cfg.mode == null;
          message = ''Please choose `nix.optimise.mode` to be either `sync` or `async`'';
        }
      ];
    }
    (mkIf (cfg.mode == "sync") {
      nix.settings.auto-optimise-store = mkDefault true;
    })
    (mkIf (cfg.mode == "async") {
      nix.settings.auto-optimise-store = mkDefault false;

      systemd.services.nix-optimise = {
        description = "Nix Store Optimiser";
        unitConfig = {
          ConditionACPower = true;
          # No point this if the nix daemon (and thus the nix store) is outside
          ConditionPathIsReadWrite = "/nix/var/nix/daemon-socket";
        };
        serviceConfig = {
          ExecStart = "${lib.getExe' config.nix.package "nix-store"} --optimise";
          Nice = 19;
          CPUSchedulingPolicy = "idle";
          IOSchedulingClass = "idle";
        };
        startAt = cfg.dates;
        # do not start and delay when switching
        restartIfChanged = false;
      };

      systemd.timers.nix-optimise = {
        RandomizedDelaySec = cfg.randomizedDelaySec;
        Persistent = cfg.persistent;
      };
    })
  ]);

  meta.maintainers = with lib.maintainers; [ qweered ];
}
