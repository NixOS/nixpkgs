{ config, pkgs, ... }:

###### implementation

let

  tempConf = "/var/run/mdadm.conf";
  logFile = "/var/log/mdadmEvents.log";
  modprobe = config.system.sbin.modprobe;
  inherit (pkgs) mdadm;

  mdadmEventHandler = pkgs.writeScript "mdadmEventHandler.sh" ''
    #!/bin/sh

    echo "$@" >> ${logFile}
    case $1 in
      (NewArray)
        initctl emit -n new-devices
        ;;
      (*) ;;
    esac
  '';

in
  
{

  jobs.swraid =
    { startOn = [ "startup" "new-devices" ];
      
      script =
        ''
          # Load the necessary RAID personalities.
          # !!! hm, doesn't the kernel load these automatically?
          for mod in raid0 raid1 raid5; do
              ${modprobe}/sbin/modprobe $mod || true
          done
      
          # Scan /proc/partitions for RAID devices.
          ${mdadm}/sbin/mdadm --examine --brief --scan -c partitions > ${tempConf}
          
          if ! test -s ${tempConf}; then exit 0; fi
      
          # Activate each device found.
          ${mdadm}/sbin/mdadm --assemble -c ${tempConf} --scan
        '';

      task = true;
    };

  jobs.swraidEvents = {
    name = "swraid-events";
    description = "Watch mdadm events.";
    startOn = [ "startup" ];
    exec = "${mdadm}/sbin/mdadm --monitor --scan --program ${mdadmEventHandler}";
  };

}
