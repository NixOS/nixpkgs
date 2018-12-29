{ config, lib, pkgs, ... }:

with lib;

let
  cpupower = config.boot.kernelPackages.cpupower;
  cfg = config.powerManagement.cpufreq;
in

{
  ###### interface

  options.powerManagement.cpufreq = {

    governor = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "ondemand";
      description = ''
        Configure the governor used to regulate the frequence of the
        available CPUs. By default, the kernel configures the
        performance governor, although this may be overwriten in your
        hardware-configuration.nix file.

        Often used values: "ondemand", "powersave", "performance"
      '';
    };

    max = mkOption {
      type = types.nullOr types.ints.unsigned;
      default = null;
      example = 2200000;
      description = ''
        The maximum frequency the CPU will use.  Defaults to the maximum possible.
      '';
    };

    min = mkOption {
      type = types.nullOr types.ints.unsigned;
      default = null;
      example = 800000;
      description = ''
        The minimum frequency the CPU will use.
      '';
    };

  };


  ###### implementation

  config =
    let
      governorEnable = cfg.governor != null;
      maxEnable = cfg.max != null;
      minEnable = cfg.min != null;
      enable =
        !config.boot.isContainer &&
        (governorEnable || maxEnable || minEnable);
    in
    mkIf enable {

      boot.kernelModules = optional governorEnable "cpufreq_${cfg.governor}";

      environment.systemPackages = [ cpupower ];

      systemd.services.cpufreq = {
        description = "CPU Frequency Setup";
        after = [ "systemd-modules-load.service" ];
        wantedBy = [ "multi-user.target" ];
        path = [ cpupower pkgs.kmod ];
        unitConfig.ConditionVirtualization = false;
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = "yes";
          ExecStart = "${cpupower}/bin/cpupower frequency-set " +
            optionalString governorEnable "--governor ${cfg.governor} " +
            optionalString maxEnable "--max ${toString cfg.max} " +
            optionalString minEnable "--min ${toString cfg.min} ";
          SuccessExitStatus = "0 237";
        };
      };

  };
}
