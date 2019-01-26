{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.services.undervolt;
in {
  options.services.undervolt = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to undervolt intel cpus.
      '';
    };

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
      type = types.nullOr types.str;
      default = null;
      description = ''
        The amount of voltage to offset the CPU cores by. Accepts a floating point number.
      '';
    };

    gpuOffset = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        The amount of voltage to offset the GPU by. Accepts a floating point number.
      '';
    };

    uncoreOffset = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        The amount of voltage to offset uncore by. Accepts a floating point number.
      '';
    };

    analogioOffset = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        The amount of voltage to offset analogio by. Accepts a floating point number.
      '';
    };

    temp = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        The temperature target. Accepts a floating point number.
      '';
    };

    tempAc = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        The temperature target on AC power. Accepts a floating point number.
      '';
    };

    tempBat = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        The temperature target on battery power. Accepts a floating point number.
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

        # `core` and `cache` are both intentionally set to `cfg.coreOffset` as according to the undervolt docs:
        #
        #     Core or Cache offsets have no effect. It is not possible to set different offsets for
        #     CPU Core and Cache. The CPU will take the smaller of the two offsets, and apply that to
        #     both CPU and Cache. A warning message will be displayed if you attempt to set different offsets.
        ExecStart = ''
          ${pkgs.undervolt}/bin/undervolt \
            ${optionalString cfg.verbose "--verbose"} \
            ${optionalString (cfg.coreOffset != null) "--core ${cfg.coreOffset}"} \
            ${optionalString (cfg.coreOffset != null) "--cache ${cfg.coreOffset}"} \
            ${optionalString (cfg.gpuOffset != null) "--gpu ${cfg.gpuOffset}"} \
            ${optionalString (cfg.uncoreOffset != null) "--uncore ${cfg.uncoreOffset}"} \
            ${optionalString (cfg.analogioOffset != null) "--analogio ${cfg.analogioOffset}"} \
            ${optionalString (cfg.temp != null) "--temp ${cfg.temp}"} \
            ${optionalString (cfg.tempAc != null) "--temp-ac ${cfg.tempAc}"} \
            ${optionalString (cfg.tempBat != null) "--temp-bat ${cfg.tempBat}"}
        '';
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
