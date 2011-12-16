{ config, pkgs, ... }:

with pkgs.lib;

{
  ###### interface

  options = {
    cpuFreqGovernor = mkOption {
      default = "";
      example = "ondemand";
      description = ''
        Configure the governor used to regulate the frequence of the
        available CPUs. By default, the kernel configures the governor
        "userspace".
      '';
    };
  };


  ###### implementation

  config = mkIf (config.cpuFreqGovernor != "") ({
    jobs.cpuFreq =
      { description = "Initialize CPU frequency governor";

        startOn = "started udev";

        task = true;

        script = ''
          for i in $(seq 0 $(($(nproc) - 1))); do
            ${pkgs.cpufrequtils}/bin/cpufreq-set -g ${config.cpuFreqGovernor} -c $i
          done
        '';
      };
  });

}
