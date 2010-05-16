{ config, pkgs, ... }:

###### implementation

let

  tempConf = "/var/run/mdadm.conf";
  tempStatus = "/var/run/mdadm.status";
  logFile = "/var/log/mdadmEvents.log";
  modprobe = config.system.sbin.modprobe;
  inherit (pkgs) mdadm diffutils;

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

      # Wait until we can fetch the status of mdadm devices.
      while ! test -e /proc/mdstat; do
        sleep 10
      done

      # Scan /proc/partitions for RAID devices.
      ${mdadm}/sbin/mdadm --examine --brief --scan -c partitions > ${tempConf}

      # If there is some array to assemble and if the status has changed.
      if test -e /proc/mdstat -a -s ${tempConf} &&
         ! ${diffutils}/bin/diff -q /proc/mdstat ${tempStatus} > /dev/null; then

        # Keep the previous status to watch changes.
        cp ${tempStatus} ${tempStatus}.old

        try=0
        # Loop until the status change.
        while ${diffutils}/bin/diff -q ${tempStatus} ${tempStatus}.old > /dev/null; do
          test "$try" -gt 12 && break
          test "$try" -ne 0 && sleep 10

          # Activate each device found.
          ${mdadm}/sbin/mdadm --assemble -c ${tempConf} --scan

          # Register the new status
          cp /proc/mdstat ${tempStatus}

          try=$(($try + 1))
        done

        if test "$try" -le 6; then
          # Send notifications.
          initctl emit -n new-devices
        fi

        # Remove previous status.
        rm ${tempStatus}.old
      fi
    '';

    task = true;
  };

  jobs.swraidEvents = {
    name = "swraid-events";
    description = "Watch mdadm events.";
    startOn = [ "startup" ];

    postStart = ''
      echo > ${tempConf}
      echo > ${tempStatus}

      # Assemble early raid devices.
      initctl emit -n new-raid-array
    '';

    # !!! Someone should ensure that this is indeed doing what the manual says.
    exec = "${mdadm}/sbin/mdadm --monitor --scan --program ${mdadmEventHandler}";
  };

}
