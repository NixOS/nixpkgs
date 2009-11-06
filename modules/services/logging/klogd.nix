{ config, pkgs, ... }:

###### implementation

{

  jobs.klogd =
    { description = "Kernel log daemon";

      startOn = "started syslogd";
      stopOn = "shutdown";

      exec =
        "${pkgs.sysklogd}/sbin/klogd -c 1 -2 -n " +
        "-k $(dirname $(readlink -f /var/run/booted-system/kernel))/System.map";
    };
    
}
