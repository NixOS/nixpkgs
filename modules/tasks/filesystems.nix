{pkgs, config, ...}:

let

###### interface
  inherit (pkgs.lib) mkOption types;

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

      options =  {

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
          default = "defaults";
          example = "data=journal";
          type = types.string;
          merge = pkgs.lib.concatStringsSep ",";
          description = "
            Option used to mount the file system.
          ";
        };

        autocreate = mkOption {
          default = "0";
          type = types.uniq types.string;
          description = "
            Automatically create the mount point defined in
            <option>fileSystems.*.mountPoint</option>.
          ";
        };
      };
    };
  
    system.sbin.mount = mkOption {
      internal = true;
      default = pkgs.utillinuxng.override {
        buildMountOnly = true;
        mountHelpers = pkgs.buildEnv {
          name = "mount-helpers";
          paths = [
            pkgs.ntfs3g
            pkgs.mount_cifs
            pkgs.nfsUtils
          ];
          pathsToLink = "/sbin";
        } + "/sbin";
      };
      description = "
        A patched `mount' command that looks in a directory in the Nix
        store instead of in /sbin for mount helpers (like mount.ntfs-3g or
        mount.cifs).
      ";
    };
    
  };

###### implementation

  inherit (pkgs) e2fsprogs;
  fileSystems = config.fileSystems;
  mountPoints = map (fs: fs.mountPoint) fileSystems;
  devices = map (fs: if fs.device != null then fs.device else "LABEL=" + fs.label) fileSystems;
  fsTypes = map (fs: fs.fsType) fileSystems;
  optionss = map (fs: fs.options) fileSystems;
  autocreates = map (fs: fs.autocreate) fileSystems;
  mount = config.system.sbin.mount;

  job = ''
    start on startup
    start on new-devices
    start on ip-up

    script
      PATH=${e2fsprogs}/sbin:$PATH

      mountPoints=(${toString mountPoints})  
      devices=(${toString devices})
      fsTypes=(${toString fsTypes})
      optionss=(${toString optionss})
      autocreates=(${toString autocreates})

      newDevices=1

      # If we mount any file system, we repeat this loop, because new
      # mount opportunities may have become available (such as images
      # for loopback mounts).

      while test -n "$newDevices"; do

        newDevices=

        for ((n = 0; n < ''${#mountPoints[*]}; n++)); do
          mountPoint=''${mountPoints[$n]}
          device=''${devices[$n]}
          fsType=''${fsTypes[$n]}
          options=''${optionss[$n]}
          autocreate=''${autocreates[$n]}

          isLabel=
          if echo "$device" | grep -q '^LABEL='; then isLabel=1; fi

          isPseudo=
          if test "$fsType" = "nfs" || test "$fsType" = "tmpfs" ||
            test "$fsType" = "ext3cow"; then isPseudo=1; fi

          if ! test -n "$isLabel" -o -n "$isPseudo" -o -e "$device"; then
              echo "skipping $device, doesn't exist (yet)"
              continue
          fi

          # !!! quick hack: if mount point already exists, try a
          # remount to change the options but nothing else.
          if cat /proc/mounts | grep -F -q " $mountPoint "; then
              echo "remounting $device on $mountPoint"
              ${mount}/bin/mount -t "$fsType" \
                  -o remount,"$options" \
                  "$device" "$mountPoint" || true
              continue
          fi

          # If $device is already mounted somewhere else, unmount it first.
          # !!! Note: we use /etc/mtab, not /proc/mounts, because mtab
          # contains more accurate info when using loop devices.

          # !!! not very smart about labels yet; should resolve the label somehow.
          if test -z "$isLabel" -a -z "$isPseudo"; then

            device=$(readlink -f "$device")

            prevMountPoint=$(
                cat /etc/mtab \
                | grep "^$device " \
                | sed 's|^[^ ]\+ \+\([^ ]\+\).*|\1|' \
            )

            if test "$prevMountPoint" = "$mountPoint"; then
                echo "remounting $device on $mountPoint"
                ${mount}/bin/mount -t "$fsType" \
                    -o remount,"$options" \
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

          if test "$autocreate" = 1; then mkdir -p "$mountPoint"; fi

          if ${mount}/bin/mount -t "$fsType" -o "$options" "$device" "$mountPoint"; then
              newDevices=1
          fi

        done

      done

    end script
  '';
in

{
  require = [options];
  services = {
    extraJobs = [{
      name = "filesystems";
      inherit job;
    }];
  };
}
