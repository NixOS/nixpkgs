{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.services.undervolt;
  cliArgs = lib.cli.toGNUCommandLineShell {} {
    inherit (cfg)
      verbose
      temp
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
  };
in
{
  options.services.undervolt = {
    enable = mkEnableOption ''
       Undervolting service for Intel CPUs.

       Warning: This service is not endorsed by Intel and may permanently damage your hardware. Use at your own risk!
    '';

    verbose = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable verbose logging.
      '';
    };

    package = mkOption {
      type = types.package;
      default = pkgs.undervolt;
      defaultText = "pkgs.undervolt";
      description = ''
        undervolt derivation to use.
      '';
    };

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
        The temperature target in Celsius degrees.
      '';
    };

    tempAc = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        The temperature target on AC power in Celsius degrees.
      '';
    };

    tempBat = mkOption {
      type = types.nullOr types.int;
      default = null;
      description = ''
        The temperature target on battery power in Celsius degrees.
      '';
    };
  };

  config = mkIf cfg.enable {
    boot.kernelModules = [ "msr" ];

    environment.systemPackages = [ cfg.package ];

    systemd.services.undervolt = {
      path = [ pkgs.undervolt ];

      description = "Intel Undervolting Service";
      serviceConfig = {
        Type = "oneshot";
        Restart = "no";
        ExecStart = "${pkgs.undervolt}/bin/undervolt ${cliArgs}";
      };
    };

    systemd.timers.undervolt = {
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
