{ config, lib, pkgs, utils, ... }:

with lib;
with utils;

let

  fileSystems = attrValues config.fileSystems;

  prioOption = prio: optionalString (prio !=null) " pri=${toString prio}";

  fileSystemOpts = { name, ... }: {

    options = {

      mountPoint = mkOption {
        example = "/mnt/usb";
        type = types.str;
        description = "Location of the mounted the file system.";
      };

      device = mkOption {
        default = null;
        example = "/dev/sda";
        type = types.uniq (types.nullOr types.string);
        description = "Location of the device.";
      };

      label = mkOption {
        default = null;
        example = "root-partition";
        type = types.uniq (types.nullOr types.string);
        description = "Label of the device (if any).";
      };

      fsType = mkOption {
        default = "auto";
        example = "ext3";
        type = types.str;
        description = "Type of the file system.";
      };

      options = mkOption {
        default = "defaults,relatime";
        example = "data=journal";
        type = types.commas;
        description = "Options used to mount the file system.";
      };

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

      noCheck = mkOption {
        default = false;
        type = types.bool;
        description = "Disable running fsck on this filesystem.";
      };

    };

    config = {
      mountPoint = mkDefault name;
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
          options = "data=journal";
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
        <option>-o</option> flag; defaults to <literal>"defaults"</literal>).

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
      type = types.listOf types.string;
      description = "Names of supported filesystem types.";
    };

    boot.initrd.supportedFilesystems = mkOption {
      default = [ ];
      example = [ "btrfs" ];
      type = types.listOf types.string;
      description = "Names of supported filesystem types in the initial ramdisk.";
    };

  };


  ###### implementation

  config = {

    boot.supportedFilesystems = map (fs: fs.fsType) fileSystems;

    boot.initrd.supportedFilesystems =
      map (fs: fs.fsType)
        (filter (fs: fs.mountPoint == "/" || fs.neededForBoot) fileSystems);

    # Add the mount helpers to the system path so that `mount' can find them.
    system.fsPackages = [ pkgs.dosfstools ];

    environment.systemPackages =
      [ pkgs.ntfs3g pkgs.cifs_utils pkgs.fuse ]
      ++ config.system.fsPackages;

    environment.etc.fstab.text =
      ''
        # This is a generated file.  Do not edit!

        # Filesystems.
        ${flip concatMapStrings fileSystems (fs:
            (if fs.device != null then fs.device else "/dev/disk/by-label/${fs.label}")
            + " " + fs.mountPoint
            + " " + fs.fsType
            + " " + fs.options
            + " 0"
            + " " + (if fs.fsType == "none" || fs.device == "none" || fs.fsType == "btrfs" || fs.fsType == "tmpfs" || fs.noCheck then "0" else
                     if fs.mountPoint == "/" then "1" else "2")
            + "\n"
        )}

        # Swap devices.
        ${flip concatMapStrings config.swapDevices (sw:
            "${sw.device} none swap${prioOption sw.priority}\n"
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
            # -F needed to allow bare block device without partitions
            mkfsOpts = optional ((builtins.substring 0 3 fs.fsType) == "ext") "-F";
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
                  mkfs.${fs.fsType} ${concatStringsSep " " mkfsOpts} "${fs.device}"
                fi
              '';
            unitConfig.RequiresMountsFor = [ "${dirOf fs.device}" ];
            unitConfig.DefaultDependencies = false; # needed to prevent a cycle
            serviceConfig.Type = "oneshot";
          };

      in listToAttrs (map formatDevice (filter (fs: fs.autoFormat) fileSystems));

    lib.fileSystems = let
      # The initrd only has to mount / or any FS marked as necessary for
      # booting (such as the FS containing /nix/store, or an FS needed for
      # mounting /, like / on a loopback).
      fsList = filter (fs: fs.neededForBoot || elem fs.mountPoint [ "/" "/nix" "/nix/store" "/var" "/var/log" "/var/lib" "/etc" ]) (attrValues config.fileSystems);

      # Returns the file system to be mounted in order to access the given path.
      # Heuristic: we find the file system with the mount point having the longest prefix for the given path.
      # If the given path has prefix /dev/* then it returns null.
      # Example: for mount points /, /a, /a/b, it returns /a/b in order to access the path /a/b/c.
      requiredForPath = fileSystems: path:
        if path == null || hasPrefix "/dev/" path
          then null
          else fold (fs: best: if (hasPrefix fs.mountPoint path &&
                                   (best == null || stringLength fs.mountPoint > stringLength best.mountPoint)) then fs else best)
                    null fileSystems;

      in {
        # Detect bind mount in case of NixOS installation in a subdirectory of the device.
        # If /dev/x is mounted to /mnt/root, and /mnt/root/nixos is bind mounted to /, then rootDirectory is /nixos.
        rootDirectory =
          let 
            optList = splitString "," config.fileSystems."/".options;
            path = config.fileSystems."/".device;
            dep = requiredForPath fsList path;
          in if elem "bind" optList && dep != null
            then substring (stringLength dep.mountPoint) (stringLength path) path
            else "/";

        # Returns a the list of file systems in the right order for mount at boot time, to be used in the initrd.
        orderedForBoot = 
          let
            # Returns the closure of dependencies of the given file system.
            # If the file system / has device /mnt/a/b, and there's a mount point /mnt/a, then it returns [ /mnt/a / ]
            # 'visited' is the list of file systems already taken into account, to avoid cycles and duplicates.
            fsClosure = fs: visited:
              let dep = requiredForPath fsList fs.device;
                  depClosure = optionals (dep != null) (fsClosure dep (visited ++ [ fs ]));
              in if elem fs visited then [ ] else depClosure ++ [ fs ];
          in fold (fs: list: list ++ (fsClosure fs list)) [ ] fsList;
      };

  };

}
