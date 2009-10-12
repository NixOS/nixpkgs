{ config, pkgs, ... }:

###### implementation

let

  klogdCmd = "${pkgs.sysklogd}/sbin/klogd -c 1 -2 -k $(dirname $(readlink -f /var/run/booted-system/kernel))/System.map";

in

{

  jobs.klogd =
    { description = "Kernel log daemon";

      startOn = "syslogd";
      stopOn = "shutdown";

      preStart =
        ''
          # !!! this hangs for some reason (it blocks reading from
          # /proc/kmsg).
          #${klogdCmd} -o
        '';

      exec = "${klogdCmd} -n";
    };
    
}
