{ config, lib, pkgs, ... }:

with lib;

let
  cpupower = config.boot.kernelPackages.cpupower;
  cfg = config.powerManagement;
in

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

  config = mkIf (!config.boot.isContainer && config.powerManagement.cpuFreqGovernor != null) {

    boot.kernelModules = [ "cpufreq_${cfg.cpuFreqGovernor}" ];

    environment.systemPackages = [ cpupower ];

    systemd.services.cpufreq = {
      description = "CPU Frequency Governor Setup";
      after = [ "systemd-modules-load.service" ];
      wantedBy = [ "multi-user.target" ];
      path = [ cpupower config.system.sbin.modprobe ];
      unitConfig.ConditionVirtualization = false;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
        ExecStart = "${cpupower}/bin/cpupower frequency-set -g ${cfg.cpuFreqGovernor}";
        SuccessExitStatus = "0 237";
      };
    };

  };
}
