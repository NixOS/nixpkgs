{ config, lib, pkgs, ... }:

with lib;

let
  cpupower = config.boot.kernelPackages.cpupower;
  cfg = config.powerManagement;
in

{
  ###### interface

  options.powerManagement = {

    # TODO: This should be aliased to powerManagement.cpufreq.governor.
    # https://github.com/NixOS/nixpkgs/pull/53041#commitcomment-31825338
    cpuFreqGovernor = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "ondemand";
      description = lib.mdDoc ''
        Configure the governor used to regulate the frequency of the
        available CPUs. By default, the kernel configures the
        performance governor, although this may be overwritten in your
        hardware-configuration.nix file.

        Often used values: "ondemand", "powersave", "performance"
      '';
    };

    cpufreq = {

      max = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        example = 2200000;
        description = lib.mdDoc ''
          The maximum frequency the CPU will use.  Defaults to the maximum possible.
        '';
      };

      min = mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        example = 800000;
        description = lib.mdDoc ''
          The minimum frequency the CPU will use.
        '';
      };
    };

  };


  ###### implementation

  config =
    let
      governorEnable = cfg.cpuFreqGovernor != null;
      maxEnable = cfg.cpufreq.max != null;
      minEnable = cfg.cpufreq.min != null;
      enable =
        !config.boot.isContainer &&
        (governorEnable || maxEnable || minEnable);
    in
    mkIf enable {

      boot.kernelModules = optional governorEnable "cpufreq_${cfg.cpuFreqGovernor}";

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
            optionalString governorEnable "--governor ${cfg.cpuFreqGovernor} " +
            optionalString maxEnable "--max ${toString cfg.cpufreq.max} " +
            optionalString minEnable "--min ${toString cfg.cpufreq.min} ";
          SuccessExitStatus = "0 237";
        };
      };

  };
}
