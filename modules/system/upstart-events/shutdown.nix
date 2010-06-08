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


          # Kill all remaining processes except init and this one.
          echo "sending the TERM signal to all processes..."
          kill -TERM -1
      
          sleep 1 # wait briefly

          echo "sending the KILL signal to all processes..."
          kill -KILL -1


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
                
      
          # Set the hardware clock to the system time.
          echo "setting the hardware clock..."
          hwclock --systohc --utc


          # Stop all swap devices.
          swapoff -a
      
      
          # Unmount helper functions.
          getMountPoints() {
              cat /proc/mounts \
              | grep -v '^rootfs' \
              | sed 's|^[^ ]\+ \+\([^ ]\+\).*|\1|' \
              | grep -v '/proc\|/sys\|/dev'
          }
      
          getDevice() {
              local mountPoint=$1
              cat /proc/mounts \
              | grep -v '^rootfs' \
              | grep "^[^ ]\+ \+$mountPoint \+" \
              | sed 's|^\([^ ]\+\).*|\1|'
          }
      
          # Unmount file systems.  We repeat this until no more file systems
          # can be unmounted.  This is to handle loopback devices, file
          # systems  mounted on other file systems and so on.
          tryAgain=1
          while test -n "$tryAgain"; do
              tryAgain=
      
              for mp in $(getMountPoints); do
                  device=$(getDevice $mp)
                  echo "unmounting $mp..."

                  # We need to remount,ro before attempting any
                  # umount, or bind mounts may get confused, with
                  # the fs not being properly flushed at the end.

                  # `-i' is to workaround a bug in mount.cifs (it
                  # doesn't recognise the `remount' option, and
                  # instead mounts the FS again).
                  mount -t none -n -i -o remount,ro none "$mp"

                  # Note: don't use `umount -f'; it's very buggy.
                  # (For instance, when applied to a bind-mount it
                  # unmounts the target of the bind-mount.)  !!! But
                  # we should use `-f' for NFS.
                  if umount -n "$mp"; then
                      if test "$mp" != /; then tryAgain=1; fi
                  fi
      
                  # Hack: work around a bug in mount (mount -o remount on a
                  # loop device forgets the loop=/dev/loopN entry in
                  # /etc/mtab).
                  if echo "$device" | grep -q '/dev/loop'; then
                      echo "removing loop device $device..."
                      losetup -d "$device"
                  fi
              done
          done


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
