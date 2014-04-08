{ config, pkgs, ... }:

let
  cpupower = config.boot.kernelPackages.cpupower;
  cfg = config.powerManagement;
in

with pkgs.lib;

{
  ###### interface

  options = {

    powerManagement.cpuFreqGovernor = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "ondemand";
      description = ''
        Configure the governor used to regulate the frequence of the
        available CPUs. By default, the kernel configures the
        on-demand governor.
      '';
    };

  };


  ###### implementation

  config = mkIf (config.powerManagement.cpuFreqGovernor != null) {

    boot.kernelModules = [ "acpi-cpufreq" "speedstep-lib" "pcc-cpufreq"
      "cpufreq_${cfg.cpuFreqGovernor}"
    ];

    environment.systemPackages = [ cpupower ];

    systemd.services.cpufreq = {
      description = "CPU Frequency Governor Setup";
      after = [ "systemd-modules-load.service" ];
      wantedBy = [ "multi-user.target" ];
      path = [ cpupower ];
      script = ''
        cpupower frequency-set -g ${cfg.cpuFreqGovernor}
      '';
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
      };
    };

  };
}
