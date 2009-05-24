{pkgs, config, ...}:

###### implementation
let
  inherit (pkgs.lib);

  klogdCmd = "${pkgs.sysklogd}/sbin/klogd -c 1 -2 -k $(dirname $(readlink -f /var/run/booted-system/kernel))/System.map";

in

{

  services = {
    extraJobs = [{
      name = "klogd";
      
      job = ''
        description "Kernel log daemon"
      
        start on syslogd
        stop on shutdown

        start script
          # !!! this hangs for some reason (it blocks reading from
          # /proc/kmsg).
          #${klogdCmd} -o
        end script

        respawn ${klogdCmd} -n
      '';
    }];
  };
}
