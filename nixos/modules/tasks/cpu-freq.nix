{ config, pkgs, ... }:

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

    environment.systemPackages = [ pkgs.cpufrequtils ];

    jobs.cpufreq =
      { description = "CPU Frequency Governor Setup";

        after = [ "systemd-modules-load.service" ];
        wantedBy = [ "multi-user.target" ];

        unitConfig.ConditionPathIsReadWrite = "/sys/devices/";

        path = [ pkgs.cpufrequtils ];

        preStart = ''
          for i in $(seq 0 $(($(nproc) - 1))); do
            for gov in $(cpufreq-info -c $i -g); do
              if [ "$gov" = ${config.powerManagement.cpuFreqGovernor} ]; then
                echo "<6>setting governor on CPU $i to ‘$gov’"
                cpufreq-set -c $i -g $gov
              fi
            done
          done
        '';
      };
  };

}
