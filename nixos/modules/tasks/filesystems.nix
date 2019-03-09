{ config, lib, pkgs, utils, ... }:

with lib;
with utils;

let

  addCheckDesc = desc: elemType: check: types.addCheck elemType check
    // { description = "${elemType.description} (with check: ${desc})"; };
  nonEmptyStr = addCheckDesc "non-empty" types.str
    (x: x != "" && ! (all (c: c == " " || c == "\t") (stringToCharacters x)));

  fileSystems' = toposort fsBefore (attrValues config.fileSystems);

  fileSystems = if fileSystems' ? "result"
                then # use topologically sorted fileSystems everywhere
                     fileSystems'.result
                else # the assertion below will catch this,
                     # but we fall back to the original order
                     # anyway so that other modules could check
                     # their assertions too
                     (attrValues config.fileSystems);

  prioOption = prio: optionalString (prio != null) " pri=${toString prio}";

  specialFSTypes = [ "proc" "sysfs" "tmpfs" "ramfs" "devtmpfs" "devpts" ];

  coreFileSystemOpts = { name, config, ... }: {

    options = {

      mountPoint = mkOption {
        example = "/mnt/usb";
        type = nonEmptyStr;
        description = "Location of the mounted the file system.";
      };

      device = mkOption {
        default = null;
        example = "/dev/sda";
        type = types.nullOr nonEmptyStr;
        description = "Location of the device.";
      };

      fsType = mkOption {
        default = "auto";
        example = "ext3";
        type = nonEmptyStr;
        description = "Type of the file system.";
      };

      options = mkOption {
        default = [ "defaults" ];
        example = [ "data=journal" ];
        description = "Options used to mount the file system.";
        type = types.listOf nonEmptyStr;
      };

    };

    config = {
      mountPoint = mkDefault name;
      device = mkIf (elem config.fsType specialFSTypes) (mkDefault config.fsType);
    };

  };

  fileSystemOpts = { config, ... }: {

    options = {

      label = mkOption {
        default = null;
        example = "root-partition";
        type = types.nullOr nonEmptyStr;
        description = "Label of the device (if any).";
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

    config = let
      defaultFormatOptions =
        # -F needed to allow bare block device without partitions
        if (builtins.substring 0 3 config.fsType) == "ext" then "-F"
        # -q needed for non-interactive operations
        else if config.fsType == "jfs" then "-q"
        # (same here)
        else if config.fsType == "reiserfs" then "-q"
        else null;
    in {
      options = mkIf config.autoResize [ "x-nixos.autoresize" ];
      formatOptions = mkIf (defaultFormatOptions != null) (mkDefault defaultFormatOptions);
    };

  };

  # Makes sequence of `specialMount device mountPoint options fsType` commands.
  # `systemMount` should be defined in the sourcing script.
  makeSpecialMounts = mounts:
    pkgs.writeText "mounts.sh" (concatMapStringsSep "\n" (mount: ''
      specialMount "${mount.device}" "${mount.mountPoint}" "${concatStringsSep "," mount.options}" "${mount.fsType}"
    '') mounts);

in

{

  ###### interface

  options = {

    fileSystems = mkOption {
      default = {};
      example = literalExample ''
        {
          "/".device = "/dev/hda1";
          "/data" = {
            device = "/dev/hda2";
            fsType = "ext3";
            options = [ "data=journal" ];
          };
          "/bigdisk".label = "bigdisk";
        }
      '';
      type = types.loaOf (types.submodule [coreFileSystemOpts fileSystemOpts]);
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

    boot.specialFileSystems = mkOption {
      default = {};
      type = types.loaOf (types.submodule coreFileSystemOpts);
      internal = true;
      description = ''
        Special filesystems that are mounted very early during boot.
      '';
    };

  };


  ###### implementation

  config = {

    assertions = let
      ls = sep: concatMapStringsSep sep (x: x.mountPoint);
    in [
      { assertion = ! (fileSystems' ? "cycle");
        message = "The ‘fileSystems’ option can't be topologically sorted: mountpoint dependency path ${ls " -> " fileSystems'.cycle} loops to ${ls ", " fileSystems'.loops}";
      }
    ];

    # Export for use in other modules
    system.build.fileSystems = fileSystems;
    system.build.earlyMountScript = makeSpecialMounts (toposort fsBefore (attrValues config.boot.specialFileSystems)).result;

    boot.supportedFilesystems = map (fs: fs.fsType) fileSystems;

    # Add the mount helpers to the system path so that `mount' can find them.
    system.fsPackages = [ pkgs.dosfstools ];

    environment.systemPackages = with pkgs; [ fuse3 fuse ] ++ config.system.fsPackages;

    environment.etc.fstab.text =
      let
        fsToSkipCheck = [ "none" "bindfs" "btrfs" "zfs" "tmpfs" "nfs" "vboxsf" "glusterfs" ];
        skipCheck = fs: fs.noCheck || fs.device == "none" || builtins.elem fs.fsType fsToSkipCheck;
        # https://wiki.archlinux.org/index.php/fstab#Filepath_spaces
        escape = string: builtins.replaceStrings [ " " "\t" ] [ "\\040" "\\011" ] string;
      in ''
        # This is a generated file.  Do not edit!
        #
        # To make changes, edit the fileSystems and swapDevices NixOS options
        # in your /etc/nixos/configuration.nix file.

        # Filesystems.
        ${concatMapStrings (fs:
            (if fs.device != null then escape fs.device
             else if fs.label != null then "/dev/disk/by-label/${escape fs.label}"
             else throw "No device specified for mount point ‘${fs.mountPoint}’.")
            + " " + escape fs.mountPoint
            + " " + fs.fsType
            + " " + builtins.concatStringsSep "," fs.options
            + " 0"
            + " " + (if skipCheck fs then "0" else
                     if fs.mountPoint == "/" then "1" else "2")
            + "\n"
        ) fileSystems}

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
            mountPoint' = "${escapeSystemdPath fs.mountPoint}.mount";
            device'  = escapeSystemdPath fs.device;
            device'' = "${device'}.device";
          in nameValuePair "mkfs-${device'}"
          { description = "Initialisation of Filesystem ${fs.device}";
            wantedBy = [ mountPoint' ];
            before = [ mountPoint' "systemd-fsck@${device'}.service" ];
            requires = [ device'' ];
            after = [ device'' ];
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

    # Sync mount options with systemd's src/core/mount-setup.c: mount_table.
    boot.specialFileSystems = {
      "/proc" = { fsType = "proc"; options = [ "nosuid" "noexec" "nodev" ]; };
      "/run" = { fsType = "tmpfs"; options = [ "nosuid" "nodev" "strictatime" "mode=755" "size=${config.boot.runSize}" ]; };
      "/dev" = { fsType = "devtmpfs"; options = [ "nosuid" "strictatime" "mode=755" "size=${config.boot.devSize}" ]; };
      "/dev/shm" = { fsType = "tmpfs"; options = [ "nosuid" "nodev" "strictatime" "mode=1777" "size=${config.boot.devShmSize}" ]; };
      "/dev/pts" = { fsType = "devpts"; options = [ "nosuid" "noexec" "mode=620" "ptmxmode=0666" "gid=${toString config.ids.gids.tty}" ]; };

      # To hold secrets that shouldn't be written to disk (generally used for NixOps, harmless elsewhere)
      "/run/keys" = { fsType = "ramfs"; options = [ "nosuid" "nodev" "mode=750" "gid=${toString config.ids.gids.keys}" ]; };
    } // optionalAttrs (!config.boot.isContainer) {
      # systemd-nspawn populates /sys by itself, and remounting it causes all
      # kinds of weird issues (most noticeably, waiting for host disk device
      # nodes).
      "/sys" = { fsType = "sysfs"; options = [ "nosuid" "noexec" "nodev" ]; };
    };

  };

}
