{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.undervolt;

  mkPLimit = limit: window:
    if (limit == null && window == null) then null
    else assert asserts.assertMsg (limit != null && window != null) "Both power limit and window must be set";
      "${toString limit} ${toString window}";
  hasCliArgs = (
    # One of the following must be set to enable the service
    (cfg.coreOffset != null) ||
    (cfg.gpuOffset != null) ||
    (cfg.uncoreOffset != null) ||
    (cfg.analogioOffset != null) ||
    (cfg.temp != null) ||
    (cfg.tempBat != null) ||
    (cfg.turbo != null) ||
    # Both limit and window must be set if either are set. This is enforced by the assertion in mkPLimit
    (cfg.p1.limit != null) ||
    (cfg.p2.limit != null)
  );
  cliArgs = lib.cli.toGNUCommandLine {} {
    inherit (cfg) verbose turbo;
    # `core` and `cache` are both intentionally set to `cfg.coreOffset` as according to the undervolt docs:
    #
    #     Core or Cache offsets have no effect. It is not possible to set different offsets for
    #     CPU Core and Cache. The CPU will take the smaller of the two offsets, and apply that to
    #     both CPU and Cache. A warning message will be displayed if you attempt to set different offsets.
    core = cfg.coreOffset;
    cache = cfg.coreOffset;
    gpu = cfg.gpuOffset;
    uncore = cfg.uncoreOffset;
    analogio = cfg.analogioOffset;

    temp = cfg.temp;
    temp-bat = cfg.tempBat;

    power-limit-long = mkPLimit cfg.p1.limit cfg.p1.window;
    power-limit-short = mkPLimit cfg.p2.limit cfg.p2.window;
  };
in
{
  imports = [
    (lib.mkRemovedOptionModule [ "options" "services" "undervolt" "tempAc" ] "Use options.services.undervolt.temp instead")
  ];

  options.services.undervolt = {
    enable = mkEnableOption ''
      Undervolting service for Intel CPUs.

      Warning: Use at your own risk! This service is not endorsed by Intel and may permanently damage your hardware
    '';

    verbose = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable verbose logging.
      '';
    };

    package = mkPackageOption pkgs "undervolt" { };

    coreOffset = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        The amount of voltage in mV to offset the CPU cores by.
      '';
    };

    gpuOffset = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        The amount of voltage in mV to offset the GPU by.
      '';
    };

    uncoreOffset = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        The amount of voltage in mV to offset uncore by.
      '';
    };

    analogioOffset = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        The amount of voltage in mV to offset analogio by.
      '';
    };

    temp = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        The temperature target on AC power in degrees Celsius.
      '';
    };

    tempBat = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        The temperature target on battery power in degrees Celsius.

        If unset, defaults to the temperature target on AC power.
      '';
    };

    turbo = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        Changes the Intel Turbo feature status (1 is disabled and 0 is enabled).
      '';
    };

    p1.limit = mkOption {
      type = with types; nullOr int;
      default = null;
      description = ''
        The P1 Power Limit in Watts.
        Both limit and window must be set.
      '';
    };
    p1.window = mkOption {
      type = with types; nullOr (oneOf [ float int ]);
      default = null;
      description = ''
        The P1 Time Window in seconds.
        Both limit and window must be set.
      '';
    };

    p2.limit = mkOption {
      type = with types; nullOr int;
      default = null;
      description = ''
        The P2 Power Limit in Watts.
        Both limit and window must be set.
      '';
    };
    p2.window = mkOption {
      type = with types; nullOr (oneOf [ float int ]);
      default = null;
      description = ''
        The P2 Time Window in seconds.
        Both limit and window must be set.
      '';
    };

    useTimer = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to set a timer that applies the undervolt settings every 30s.
        This will cause spam in the journal but might be required for some
        hardware under specific conditions.
        Enable this if your undervolt settings don't hold.
      '';
    };
  };

  config = mkIf cfg.enable {
    assertions = [ {
      assertion = hasCliArgs;
      message = ''
        At least one of the following undervolt parameters must be set to enable service.undervolt

        - services.undervolt.coreOffset
        - services.undervolt.gpuOffset
        - services.undervolt.uncoreOffset
        - services.undervolt.analogioOffset
        - services.undervolt.temp
        - services.undervolt.tempBat
        - services.undervolt.turbo
        - services.undervolt.p1.limit and services.undervolt.p1.window
        - services.undervolt.p2.limit and services.undervolt.p2.window
      '';
    } ];

    hardware.cpu.x86.msr.enable = true;

    environment.systemPackages = [ cfg.package ];

    systemd.services.undervolt = {
      description = "Intel Undervolting Service";

      # Apply undervolt on boot, nixos generation switch and resume
      wantedBy = [ "multi-user.target" "post-resume.target" ];
      after = [ "post-resume.target" ]; # Not sure why but it won't work without this

      serviceConfig = {
        Type = "oneshot";
        Restart = "no";
        ExecStart = "${cfg.package}/bin/undervolt ${toString cliArgs}";
      };
    };

    systemd.timers.undervolt = mkIf cfg.useTimer {
      description = "Undervolt timer to ensure voltage settings are always applied";
      partOf = [ "undervolt.service" ];
      wantedBy = [ "multi-user.target" ];
      timerConfig = {
        OnBootSec = "2min";
        OnUnitActiveSec = "30";
      };
    };
  };
}
