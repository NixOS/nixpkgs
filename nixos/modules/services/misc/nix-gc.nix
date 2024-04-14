{ config, lib, ... }:

let
  cfg = config.nix.gc;
in

{

  ###### interface

  options = {

    nix.gc = {

      automatic = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = "Automatically run the garbage collector at a specific time.";
      };

      dates = lib.mkOption {
        type = lib.types.singleLineStr;
        default = "03:15";
        example = "weekly";
        description = ''
          How often or when garbage collection is performed. For most desktop and server systems
          a sufficient garbage collection is once a week.

          The format is described in
          {manpage}`systemd.time(7)`.
        '';
      };

      randomizedDelaySec = lib.mkOption {
        default = "0";
        type = lib.types.singleLineStr;
        example = "45min";
        description = ''
          Add a randomized delay before each garbage collection.
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

      options = lib.mkOption {
        default = "";
        example = "--max-freed $((64 * 1024**3))";
        type = lib.types.singleLineStr;
        description = ''
          Options given to [`nix-collect-garbage`](https://nixos.org/manual/nix/stable/command-ref/nix-collect-garbage) when the garbage collector is run automatically.
        '';
      };

    };

  };


  ###### implementation

  config = {
    assertions = [
      {
        assertion = cfg.automatic -> config.nix.enable;
        message = ''nix.gc.automatic requires nix.enable'';
      }
    ];

    systemd.services.nix-gc = lib.mkIf config.nix.enable {
      description = "Nix Garbage Collector";
      script = "exec ${config.nix.package.out}/bin/nix-collect-garbage ${cfg.options}";
      serviceConfig.Type = "oneshot";
      startAt = lib.optional cfg.automatic cfg.dates;
    };

    systemd.timers.nix-gc = lib.mkIf cfg.automatic {
      timerConfig = {
        RandomizedDelaySec = cfg.randomizedDelaySec;
        Persistent = cfg.persistent;
      };
    };

  };

}
