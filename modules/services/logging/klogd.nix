{ config, pkgs, ... }:

###### implementation

{

  jobs.klogd =
    { description = "Kernel log daemon";

      startOn = "started syslogd";

      path = [ pkgs.sysklogd ];

      exec =
        "klogd -c 1 -2 -n " +
        "-k $(dirname $(readlink -f /var/run/booted-system/kernel))/System.map";
    };

}
