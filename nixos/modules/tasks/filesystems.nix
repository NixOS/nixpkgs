{ config, lib, pkgs, utils, ... }:

with lib;
with utils;

let

  fileSystems = attrValues config.fileSystems;

  prioOption = prio: optionalString (prio != null) " pri=${toString prio}";

  fileSystemOpts = { name, config, ... }: {

    options = {

      mountPoint = mkOption {
        example = "/mnt/usb";
        type = types.str;
        description = "Location of the mounted the file system.";
      };

      device = mkOption {
        default = null;
        example = "/dev/sda";
        type = types.nullOr types.str;
        description = "Location of the device.";
      };

      label = mkOption {
        default = null;
        example = "root-partition";
        type = types.nullOr types.str;
        description = "Label of the device (if any).";
      };

      fsType = mkOption {
        default = "auto";
        example = "ext3";
        type = types.str;
        description = "Type of the file system.";
      };

      options = mkOption {
        default = [ "defaults" ];
        example = [ "data=journal" ];
        description = "Options used to mount the file system.";
      } // (if versionAtLeast lib.nixpkgsVersion "16.09" then {
        type = types.listOf types.str;
      } else {
        type = types.either types.commas (types.listOf types.str);
        apply = x: if isList x then x else lib.strings.splitString "," (builtins.trace "warning: passing a comma-separated string for filesystem options is deprecated; use a list of strings instead. This will become a hard error in 16.09." x);
      });

      autoFormat = mkOption {
        default = false;
        type = types.bool;
        description = ''
          If the device does not currently contain a filesystem (as
          determined by <command>blkid</command>, then automatically
          format it with the filesystem type specified in
          <option>fsType</option>.  Use with caution.
        '';
      };

      formatOptions = mkOption {
        default = "";
        type = types.str;
        description = ''
          If <option>autoFormat</option> option is set specifies
          extra options passed to mkfs.
        '';
      };

      autoResize = mkOption {
        default = false;
        type = types.bool;
        description = ''
          If set, the filesystem is grown to its maximum size before
          being mounted. (This is typically the size of the containing
          partition.) This is currently only supported for ext2/3/4
          filesystems that are mounted during early boot.
        '';
      };

      noCheck = mkOption {
        default = false;
        type = types.bool;
        description = "Disable running fsck on this filesystem.";
      };

    };

    config = {
      mountPoint = mkDefault name;
      device = mkIf (config.fsType == "tmpfs") (mkDefault config.fsType);
      options = mkIf config.autoResize [ "x-nixos.autoresize" ];

      # -F needed to allow bare block device without partitions
      formatOptions = mkIf ((builtins.substring 0 3 config.fsType) == "ext") (mkDefault "-F");
    };

  };

in

{

  ###### interface

  options = {

    fileSystems = mkOption {
      default = {};
      example = {
        "/".device = "/dev/hda1";
        "/data" = {
          device = "/dev/hda2";
          fsType = "ext3";
          options = [ "data=journal" ];
        };
        "/bigdisk".label = "bigdisk";
      };
      type = types.loaOf types.optionSet;
      options = [ fileSystemOpts ];
      description = ''
        The file systems to be mounted.  It must include an entry for
        the root directory (<literal>mountPoint = "/"</literal>).  Each
        entry in the list is an attribute set with the following fields:
        <literal>mountPoint</literal>, <literal>device</literal>,
        <literal>fsType</literal> (a file system type recognised by
        <command>mount</command>; defaults to
        <literal>"auto"</literal>), and <literal>options</literal>
        (the mount options passed to <command>mount</command> using the
        <option>-o</option> flag; defaults to <literal>[ "defaults" ]</literal>).

        Instead of specifying <literal>device</literal>, you can also
        specify a volume label (<literal>label</literal>) for file
        systems that support it, such as ext2/ext3 (see <command>mke2fs
        -L</command>).
      '';
    };

    system.fsPackages = mkOption {
      internal = true;
      default = [ ];
      description = "Packages supplying file system mounters and checkers.";
    };

    boot.supportedFilesystems = mkOption {
      default = [ ];
      example = [ "btrfs" ];
      type = types.listOf types.str;
      description = "Names of supported filesystem types.";
    };

  };


  ###### implementation

  config = {

    boot.supportedFilesystems = map (fs: fs.fsType) fileSystems;

    # Add the mount helpers to the system path so that `mount' can find them.
    system.fsPackages = [ pkgs.dosfstools ];

    environment.systemPackages = [ pkgs.fuse ] ++ config.system.fsPackages;

    environment.etc.fstab.text =
      let
        fsToSkipCheck = [ "none" "btrfs" "zfs" "tmpfs" "nfs" "vboxsf" ];
        skipCheck = fs: fs.noCheck || fs.device == "none" || builtins.elem fs.fsType fsToSkipCheck;
      in ''
        # This is a generated file.  Do not edit!

        # Filesystems.
        ${flip concatMapStrings fileSystems (fs:
            (if fs.device != null then fs.device
             else if fs.label != null then "/dev/disk/by-label/${fs.label}"
             else throw "No device specified for mount point ‘${fs.mountPoint}’.")
            + " " + fs.mountPoint
            + " " + fs.fsType
            + " " + builtins.concatStringsSep "," fs.options
            + " 0"
            + " " + (if skipCheck fs then "0" else
                     if fs.mountPoint == "/" then "1" else "2")
            + "\n"
        )}

        # Swap devices.
        ${flip concatMapStrings config.swapDevices (sw:
            "${sw.realDevice} none swap${prioOption sw.priority}\n"
        )}
      '';

    # Provide a target that pulls in all filesystems.
    systemd.targets.fs =
      { description = "All File Systems";
        wants = [ "local-fs.target" "remote-fs.target" ];
      };

    # Emit systemd services to format requested filesystems.
    systemd.services =
      let

        formatDevice = fs:
          let
            mountPoint' = escapeSystemdPath fs.mountPoint;
            device' = escapeSystemdPath fs.device;
          in nameValuePair "mkfs-${device'}"
          { description = "Initialisation of Filesystem ${fs.device}";
            wantedBy = [ "${mountPoint'}.mount" ];
            before = [ "${mountPoint'}.mount" "systemd-fsck@${device'}.service" ];
            requires = [ "${device'}.device" ];
            after = [ "${device'}.device" ];
            path = [ pkgs.utillinux ] ++ config.system.fsPackages;
            script =
              ''
                if ! [ -e "${fs.device}" ]; then exit 1; fi
                # FIXME: this is scary.  The test could be more robust.
                type=$(blkid -p -s TYPE -o value "${fs.device}" || true)
                if [ -z "$type" ]; then
                  echo "creating ${fs.fsType} filesystem on ${fs.device}..."
                  mkfs.${fs.fsType} ${fs.formatOptions} "${fs.device}"
                fi
              '';
            unitConfig.RequiresMountsFor = [ "${dirOf fs.device}" ];
            unitConfig.DefaultDependencies = false; # needed to prevent a cycle
            serviceConfig.Type = "oneshot";
          };

      in listToAttrs (map formatDevice (filter (fs: fs.autoFormat) fileSystems));

  };

}
