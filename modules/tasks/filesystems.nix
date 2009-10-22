{ config, pkgs, ... }:

with pkgs.lib;

let

  fileSystems = config.fileSystems;
  mount = config.system.sbin.mount;

  task =
    ''
      PATH=${pkgs.e2fsprogs}/sbin:${pkgs.utillinuxng}/sbin:$PATH

      newDevices=1

      # If we mount any file system, we repeat this loop, because new
      # mount opportunities may have become available (such as images
      # for loopback mounts).

      while test -n "$newDevices"; do
        newDevices=

        ${flip concatMapStrings fileSystems
          (fs: ''
            mountPoint='${fs.mountPoint}'
            device='${if fs.device != null then fs.device else "/dev/disk/by-label/${fs.label}"}'
            fsType='${fs.fsType}'
          
            # A device is a pseudo-device (i.e. not an actual device
            # node) if it's not an absolute path (e.g. an NFS server
            # such as machine:/path), if it starts with // (a CIFS FS),
            # a known pseudo filesystem (such as tmpfs), or the device
            # is a directory (e.g. a bind mount).
            isPseudo=
            test "''${device:0:1}" != / -o "''${device:0:2}" = // -o "$fsType" = "tmpfs" \
                -o -d "$device" && isPseudo=1

            if ! test -n "$isPseudo" -o -e "$device"; then
                echo "skipping $device, doesn't exist (yet)"
                continue
            fi

            # !!! quick hack: if the mount point is already mounted, try
            # a remount to change the options but nothing else.
            if cat /proc/mounts | grep -F -q " $mountPoint "; then
                if test "''${device:0:2}" != //; then
                    echo "remounting $device on $mountPoint"
                    ${mount}/bin/mount -t "$fsType" \
                        -o remount,"${fs.options}" \
                        "$device" "$mountPoint" || true
                fi
                continue
            fi

            # If $device is already mounted somewhere else, unmount it first.
            # !!! Note: we use /etc/mtab, not /proc/mounts, because mtab
            # contains more accurate info when using loop devices.

            if test -z "$isPseudo"; then

              device=$(readlink -f "$device")

              prevMountPoint=$(
                  cat /etc/mtab \
                  | grep "^$device " \
                  | sed 's|^[^ ]\+ \+\([^ ]\+\).*|\1|' \
              )

              if test "$prevMountPoint" = "$mountPoint"; then
                  echo "remounting $device on $mountPoint"
                  ${mount}/bin/mount -t "$fsType" \
                      -o remount,"${fs.options}" \
                      "$device" "$mountPoint" || true
                  continue
              fi

              if test -n "$prevMountPoint"; then
                  echo "unmount $device from $prevMountPoint"
                  ${mount}/bin/umount "$prevMountPoint" || true
              fi

            fi

            echo "mounting $device on $mountPoint"

            # !!! should do something with the result; also prevent repeated fscks.
            if test -z "$isPseudo"; then
                fsck -a "$device" || true
            fi

            ${optionalString fs.autocreate
              ''
                mkdir -p "$mountPoint"
              ''
            }

            if ${mount}/bin/mount -t "$fsType" -o "$options" "$device" "$mountPoint"; then
                newDevices=1
            fi
          '')
        }
      done
    '';

in

{

  ###### interface

  options = {

    fileSystems = mkOption {
      example = [
        { mountPoint = "/";
          device = "/dev/hda1";
        }
        { mountPoint = "/data";
          device = "/dev/hda2";
          fsType = "ext3";
          options = "data=journal";
        }
        { mountPoint = "/bigdisk";
          label = "bigdisk";
        }
      ];
      
      description = "
        The file systems to be mounted.  It must include an entry for
        the root directory (<literal>mountPoint = \"/\"</literal>).  Each
        entry in the list is an attribute set with the following fields:
        <literal>mountPoint</literal>, <literal>device</literal>,
        <literal>fsType</literal> (a file system type recognised by
        <command>mount</command>; defaults to
        <literal>\"auto\"</literal>), and <literal>options</literal>
        (the mount options passed to <command>mount</command> using the
        <option>-o</option> flag; defaults to <literal>\"defaults\"</literal>).

        Instead of specifying <literal>device</literal>, you can also
        specify a volume label (<literal>label</literal>) for file
        systems that support it, such as ext2/ext3 (see <command>mke2fs
        -L</command>).

        <literal>autocreate</literal> forces <literal>mountPoint</literal> to be created with 
        <command>mkdir -p</command> .
      ";
      
      type = types.nullOr (types.list types.optionSet);

      options = {

        mountPoint = mkOption {
          example = "/mnt/usb";
          type = types.uniq types.string;
          description = "
            Location of the mounted the file system.
          ";
        };

        device = mkOption {
          default = null;
          example = "/dev/sda";
          type = types.uniq (types.nullOr types.string);
          description = "
            Location of the device.
          ";
        };

        label = mkOption {
          default = null;
          example = "root-partition";
          type = types.uniq (types.nullOr types.string);
          description = "
            Label of the device (if any).
          ";
        };

        fsType = mkOption {
          default = "auto";
          example = "ext3";
          type = types.uniq types.string;
          description = "
            Type of the file system.
          ";
        };

        options = mkOption {
          default = "defaults,relatime";
          example = "data=journal";
          type = types.string;
          merge = pkgs.lib.concatStringsSep ",";
          description = "
            Option used to mount the file system.
          ";
        };

        autocreate = mkOption {
          default = false;
          type = types.bool;
          description = "
            Automatically create the mount point defined in
            <option>fileSystems.*.mountPoint</option>.
          ";
        };
      };
    };
  
    system.sbin.mount = mkOption {
      internal = true;
      default = pkgs.utillinuxng;
      description = "
        Package containing mount and umount.
      ";
    };
    
  };


  ###### implementation

  config = {

    # Add the mount helpers to the system path so that `mount' can find them.
    environment.systemPackages = [pkgs.ntfs3g pkgs.mount_cifs pkgs.nfsUtils];
    
    jobs.filesystems =
      { startOn = [ "startup" "new-devices" "ip-up" ];

        script = task;

        task = true;
      };

  };

}
