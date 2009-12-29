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
        initctl emit -n new-raid-array
        ;;
      (*) ;;
    esac
  '';

in
  
{

  jobs.swraid = {
    startOn = [ "new-raid-array" ];
    description = "Assemble RAID arrays.";

    script = ''
      # Load the necessary RAID personalities.
      # !!! hm, doesn't the kernel load these automatically?
      for mod in raid0 raid1 raid5; do
        ${modprobe}/sbin/modprobe $mod || true
      done

      # Save previous probe
      mv ${tempConf} ${tempConf}.old

      # Scan /proc/partitions for RAID devices.
      ${mdadm}/sbin/mdadm --examine --brief --scan -c partitions > ${tempConf}

      if ! diff ${tempConf} ${tempConf}.old > /dev/null; then
        # Activate each device found.
        ${mdadm}/sbin/mdadm --assemble -c ${tempConf} --scan

        # Send notifications.
        initctl emit -n new-devices
      fi

      # Remove previous configuration.
      rm ${tempConf}.old
    '';

    task = true;
  };

  jobs.swraidEvents = {
    name = "swraid-events";
    description = "Watch mdadm events.";
    startOn = [ "startup" ];

    postStart = ''
      echo > ${tempConf}

      # Assemble early raid devices.
      initctl emit -n new-raid-array
    '';

    # !!! Someone should ensure that this is indeed doing what the manual says.
    exec = "${mdadm}/sbin/mdadm --monitor --scan --program ${mdadmEventHandler}";
  };

}
