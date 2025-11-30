{ config, lib, ... }:
let
  cfg = config.nix.gc;
  inherit (lib)
    mkEnableOption
    mkRenamedOptionModule
    mkOption
    types
    ;
in
{
  imports = [
    (mkRenamedOptionModule [ "nix" "gc" "automatic" ] [ "nix" "gc" "enable" ])
  ];

  options.nix.gc = {
    enable = mkEnableOption "" // {
      description = "Whether to automatically run the garbage collector at a specific time.";
    };

    dates = mkOption {
      type = with types; either singleLineStr (listOf str);
      apply = lib.toList;
      default = [ "03:15" ];
      example = "weekly";
      description = ''
        How often or when garbage collection is performed. For most desktop and server systems
        a sufficient garbage collection is once a week.

        This value must be a calendar event in the format specified by
        {manpage}`systemd.time(7)`.
      '';
    };

    randomizedDelaySec = mkOption {
      default = "0";
      type = types.singleLineStr;
      example = "45min";
      description = ''
        Add a randomized delay before each garbage collection.
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

    options = mkOption {
      default = "";
      example = "--max-freed $((64 * 1024**3))";
      type = types.singleLineStr;
      description = ''
        Options given to [`nix-collect-garbage`](https://nixos.org/manual/nix/stable/command-ref/nix-collect-garbage) when the garbage collector is run automatically.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.enable -> config.nix.enable;
        message = ''`nix.gc.enable` requires `nix.enable = true`'';
      }
    ];

    systemd.services.nix-gc = {
      description = "Nix Garbage Collector";
      # No point in this if the nix daemon (and thus the nix store) is outside
      unitConfig.ConditionPathIsReadWrite = "/nix/var/nix/daemon-socket";
      serviceConfig.ExecStart = "${config.nix.package}/bin/nix-collect-garbage ${cfg.options}";
      serviceConfig.Type = "oneshot";
      startAt = cfg.dates;
      # do not start and delay when switching
      restartIfChanged = false;
    };

    systemd.timers.nix-gc = {
      timerConfig = {
        RandomizedDelaySec = cfg.randomizedDelaySec;
        Persistent = cfg.persistent;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ qweered ];
}
