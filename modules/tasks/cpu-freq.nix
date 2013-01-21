{ config, pkgs, ... }:

with pkgs.lib;

{
  ###### interface

  options = {

    powerManagement.cpuFreqGovernor = mkOption {
      default = "";
      example = "ondemand";
      type = types.uniq types.string;
      description = ''
        Configure the governor used to regulate the frequence of the
        available CPUs. By default, the kernel configures the governor
        "userspace".
      '';
    };

  };


  ###### implementation

  config = mkIf (config.powerManagement.cpuFreqGovernor != "") {

    environment.systemPackages = [ pkgs.cpufrequtils ];

    jobs.cpufreq =
      { description = "Initialize CPU frequency governor";

        after = [ "systemd-modules-load.service" ];
        wantedBy = [ "multi-user.target" ];

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
