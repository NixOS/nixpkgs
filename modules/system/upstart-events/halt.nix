{pkgs, config, ...}:

###### implementation


let

  inherit (pkgs) bash utillinux;

  jobFun = event : {
    name = "sys-" + event;
    
    job = ''
      start on ${event}
      
      script
          set +e # continue in case of errors
      
          exec < /dev/tty1 > /dev/tty1 2>&1
          echo ""
          echo "<<< SYSTEM SHUTDOWN >>>"
          echo ""
      
          export PATH=${utillinux}/bin:${utillinux}/sbin:$PATH
      
      
          # Set the hardware clock to the system time.
          echo "Setting the hardware clock..."
          hwclock --systohc --utc || true
      
      
          # Do an initial sync just in case.
          sync || true
      
      
          # Kill all remaining processes except init and this one.
          echo "Sending the TERM signal to all processes..."
          kill -TERM -1 || true
      
          sleep 1 # wait briefly
      
          echo "Sending the KILL signal to all processes..."
          kill -KILL -1 || true
      
      
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
                  if umount -f -n "$mp"; then
                      if test "$mp" != /; then tryAgain=1; fi
                  else
                      mount -n -o remount,ro "$mp" || true
                  fi
      
                  # Hack: work around a bug in mount (mount -o remount on a
                  # loop device forgets the loop=/dev/loopN entry in
                  # /etc/mtab).
                  if echo "$device" | grep -q '/dev/loop'; then
                      echo "removing loop device $device..."
                      losetup -d "$device" || true
                  fi
              done
          done
      
          cat /proc/mounts
      
      
          # Final sync.
          sync || true
      
      
          # Either reboot or power-off the system.  Note that the "halt"
          # event also does a power-off.
          if test ${event} = reboot; then
              exec reboot -f
          else
              exec halt -f -p
          fi
      
      end script
    '';
  };

in


{
  services = {
    extraJobs = map jobFun ["reboot" "halt" "system-halt" "power-off"];
  };
}
