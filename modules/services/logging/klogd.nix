{ config, pkgs, ... }:

###### implementation

{

  jobs.klogd =
    { description = "Kernel log daemon";

      startOn = "started syslogd";

      path = [ pkgs.sysklogd ];

      exec =
        "klogd -c 1 -2 -n " +
        "-k $(dirname $(readlink -f /run/booted-system/kernel))/System.map";
    };

}
