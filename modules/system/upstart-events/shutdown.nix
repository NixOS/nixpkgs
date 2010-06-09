{ config, pkgs, ... }:

with pkgs.lib;

{

  jobs.shutdown =
    { name = "shutdown";

      task = true;

      stopOn = ""; # must override the default ("starting shutdown")

      environment = { MODE = "poweroff"; };

      extraConfig = "console owner";

      script =
        ''
          set +e # continue in case of errors

          ${pkgs.kbd}/bin/chvt 1
      
          exec < /dev/console > /dev/console 2>&1
          echo ""
          if test "$MODE" = maintenance; then
              echo "[1;32m<<< Entering maintenance mode >>>[0m"
          else
              echo "[1;32m<<< System shutdown >>>[0m"
          fi
          echo ""
      
          export PATH=${pkgs.utillinux}/bin:${pkgs.utillinux}/sbin:$PATH
      

          # Do an initial sync just in case.
          sync


          # Kill all remaining processes except init, this one and any
          # Upstart jobs that don't stop on the "starting shutdown"
          # event, as these are necessary to complete the shutdown.
          omittedPids=$(initctl list | sed -e 's/.*process \([0-9]\+\)/-o \1/;t;d')
          #echo "saved PIDs: $omittedPids"
          
          echo "sending the TERM signal to all processes..."
          ${pkgs.sysvtools}/bin/killall5 -15 $job $omittedPids
      
          sleep 1 # wait briefly

          echo "sending the KILL signal to all processes..."
          ${pkgs.sysvtools}/bin/killall5 -9 $job $omittedPids


          # If maintenance mode is requested, start a root shell, and
          # afterwards emit the "startup" event to bring everything
          # back up.
          if test "$MODE" = maintenance; then
              echo ""
              echo "[1;32m<<< Maintenance shell >>>[0m"
              echo ""
              ${pkgs.shadow}/bin/login root
              initctl emit -n startup
              exit 0
          fi


          # Write a shutdown record to wtmp while /var/log is still writable.
          reboot --wtmp-only


          # Set the hardware clock to the system time.
          echo "setting the hardware clock..."
          hwclock --systohc --utc


          # Stop all swap devices.
          swapoff -a


          # Unmount file systems.  We repeat this until no more file systems
          # can be unmounted.  This is to handle loopback devices, file
          # systems  mounted on other file systems and so on.
          tryAgain=1
          while test -n "$tryAgain"; do
              tryAgain=
              failed= # list of mount points that couldn't be unmounted/remounted

              cp /proc/mounts /dev/.mounts # don't read /proc/mounts while it's changing
              exec 4< /dev/.mounts
              while read -u 4 device mp fstype options rest; do
                  if [ "$mp" = /proc -o "$mp" = /sys -o "$mp" = /dev -o "$device" = "rootfs" -o "$mp" = /var/run ]; then continue; fi
              
                  echo "unmounting $mp..."

                  # We need to remount,ro before attempting any
                  # umount, or bind mounts may get confused, with
                  # the fs not being properly flushed at the end.

                  # `-i' is to workaround a bug in mount.cifs (it
                  # doesn't recognise the `remount' option, and
                  # instead mounts the FS again).
                  success=
                  if mount -t "$fstype" -n -i -o remount,ro "device" "$mp"; then success=1; fi

                  # Note: don't use `umount -f'; it's very buggy.
                  # (For instance, when applied to a bind-mount it
                  # unmounts the target of the bind-mount.)  !!! But
                  # we should use `-f' for NFS.
                  if [ "$mp" != / -a "$mp" != /nix/store ]; then
                      if umount -n "$mp"; then success=1; tryAgain=1; fi
                  fi

                  if [ -z "$success" ]; then failed="$failed $mp"; fi
              done
          done


          # Warn about filesystems that could not be unmounted or
          # remounted read-only.
          if [ -n "$failed" ]; then
              echo "[1;31mwarning:[0m the following filesystems could not be unmounted:"
              for mp in $failed; do echo "  $mp"; done
              sleep 5
          fi


          # Final sync.
          sync
      
      
          # Either reboot or power-off the system.
          if test "$MODE" = reboot; then
              echo "rebooting..."
              sleep 1
              exec reboot -f
          else
              echo "powering off..."
              sleep 1
              exec halt -f -p
          fi
        '';
    };

}
