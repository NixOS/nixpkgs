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
      type = types.listOf types.str;
      default = [];
      example = [ "ondemand" ];
      description = ''
        Configure the governor used to regulate the frequence of the
        available CPUs. By default, the kernel configures the
        performance governor.
      '';
    };

  };


  ###### implementation

  config = mkIf (!config.boot.isContainer && config.powerManagement.cpuFreqGovernor != []) {

    boot.kernelModules = map (x: "cpufreq_" + x) cfg.cpuFreqGovernor;

    environment.systemPackages = [ cpupower ];

    systemd.services.cpufreq = {
      description = "CPU Frequency Governor Setup";
      after = [ "systemd-modules-load.service" ];
      wantedBy = [ "multi-user.target" ];
      path = [ cpupower pkgs.kmod ];
      unitConfig.ConditionVirtualization = false;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = "yes";
        ExecStart = ''
          ${pkgs.bash}/bin/sh -c \
          "for i in ${toString cfg.cpuFreqGovernor}; do \
            ${cpupower}/bin/cpupower frequency-set -g $i && break; \
          done"
        '';
        SuccessExitStatus = "0 237";
      };
    };

  };
}
