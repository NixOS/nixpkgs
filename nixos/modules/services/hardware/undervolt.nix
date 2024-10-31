{ config, pkgs, lib, ... }:
let
  cfg = config.services.undervolt;

  mkPLimit = limit: window:
    if (limit == null && window == null) then null
    else assert lib.asserts.assertMsg (limit != null && window != null) "Both power limit and window must be set";
      "${toString limit} ${toString window}";
  cliArgs = lib.cli.toGNUCommandLine {} {
    inherit (cfg)
      verbose
      temp
      turbo
      ;
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

    temp-bat = cfg.tempBat;
    temp-ac = cfg.tempAc;

    power-limit-long = mkPLimit cfg.p1.limit cfg.p1.window;
    power-limit-short = mkPLimit cfg.p2.limit cfg.p2.window;
  };
in
{
  options.services.undervolt = {
    enable = lib.mkEnableOption ''
       Undervolting service for Intel CPUs.

       Warning: This service is not endorsed by Intel and may permanently damage your hardware. Use at your own risk
    '';

    verbose = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable verbose logging.
      '';
    };

    package = lib.mkPackageOption pkgs "undervolt" { };

    coreOffset = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = ''
        The amount of voltage in mV to offset the CPU cores by.
      '';
    };

    gpuOffset = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = ''
        The amount of voltage in mV to offset the GPU by.
      '';
    };

    uncoreOffset = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = ''
        The amount of voltage in mV to offset uncore by.
      '';
    };

    analogioOffset = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = ''
        The amount of voltage in mV to offset analogio by.
      '';
    };

    temp = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = ''
        The temperature target in Celsius degrees.
      '';
    };

    tempAc = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = ''
        The temperature target on AC power in Celsius degrees.
      '';
    };

    tempBat = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = ''
        The temperature target on battery power in Celsius degrees.
      '';
    };

    turbo = lib.mkOption {
      type = lib.types.nullOr lib.types.int;
      default = null;
      description = ''
        Changes the Intel Turbo feature status (1 is disabled and 0 is enabled).
      '';
    };

    p1.limit = lib.mkOption {
      type = with lib.types; nullOr int;
      default = null;
      description = ''
        The P1 Power Limit in Watts.
        Both limit and window must be set.
      '';
    };
    p1.window = lib.mkOption {
      type = with lib.types; nullOr (oneOf [ float int ]);
      default = null;
      description = ''
        The P1 Time Window in seconds.
        Both limit and window must be set.
      '';
    };

    p2.limit = lib.mkOption {
      type = with lib.types; nullOr int;
      default = null;
      description = ''
        The P2 Power Limit in Watts.
        Both limit and window must be set.
      '';
    };
    p2.window = lib.mkOption {
      type = with lib.types; nullOr (oneOf [ float int ]);
      default = null;
      description = ''
        The P2 Time Window in seconds.
        Both limit and window must be set.
      '';
    };

    useTimer = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to set a timer that applies the undervolt settings every 30s.
        This will cause spam in the journal but might be required for some
        hardware under specific conditions.
        Enable this if your undervolt settings don't hold.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
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

    systemd.timers.undervolt = lib.mkIf cfg.useTimer {
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
