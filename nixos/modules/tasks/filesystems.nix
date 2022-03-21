{ config, lib, pkgs, utils, ... }:

with lib;
with utils;

let

  addCheckDesc = desc: elemType: check: types.addCheck elemType check
    // { description = "${elemType.description} (with check: ${desc})"; };

  isNonEmpty = s: (builtins.match "[ \t\n]*" s) == null;
  nonEmptyStr = addCheckDesc "non-empty" types.str isNonEmpty;

  fileSystems' = toposort fsBefore (attrValues config.fileSystems);

  fileSystems = if fileSystems' ? result
                then # use topologically sorted fileSystems everywhere
                     fileSystems'.result
                else # the assertion below will catch this,
                     # but we fall back to the original order
                     # anyway so that other modules could check
                     # their assertions too
                     (attrValues config.fileSystems);

  specialFSTypes = [ "proc" "sysfs" "tmpfs" "ramfs" "devtmpfs" "devpts" ];

  nonEmptyWithoutTrailingSlash = addCheckDesc "non-empty without trailing slash" types.str
    (s: isNonEmpty s && (builtins.match ".+/" s) == null);

  coreFileSystemOpts = { name, config, ... }: {

    options = {
      mountPoint = mkOption {
        example = "/mnt/usb";
        type = nonEmptyWithoutTrailingSlash;
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

      depends = mkOption {
        default = [ ];
        example = [ "/persist" ];
        type = types.listOf nonEmptyWithoutTrailingSlash;
        description = ''
          List of paths that should be mounted before this one. This filesystem's
          <option>device</option> and <option>mountPoint</option> are always
          checked and do not need to be included explicitly. If a path is added
          to this list, any other filesystem whose mount point is a parent of
          the path will be mounted before this filesystem. The paths do not need
          to actually be the <option>mountPoint</option> of some other filesystem.
        '';
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
      example = literalExpression ''
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
      type = types.attrsOf (types.submodule [coreFileSystemOpts fileSystemOpts]);
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
      type = types.attrsOf (types.submodule coreFileSystemOpts);
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
      notAutoResizable = fs: fs.autoResize && !(hasPrefix "ext" fs.fsType || fs.fsType == "f2fs");
    in [
      { assertion = ! (fileSystems' ? cycle);
        message = "The ‘fileSystems’ option can't be topologically sorted: mountpoint dependency path ${ls " -> " fileSystems'.cycle} loops to ${ls ", " fileSystems'.loops}";
      }
      { assertion = ! (any notAutoResizable fileSystems);
        message = let
          fs = head (filter notAutoResizable fileSystems);
        in
          "Mountpoint '${fs.mountPoint}': 'autoResize = true' is not supported for 'fsType = \"${fs.fsType}\"':${if fs.fsType == "auto" then " fsType has to be explicitly set and" else ""} only the ext filesystems and f2fs support it.";
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
        fsToSkipCheck = [ "none" "bindfs" "btrfs" "zfs" "tmpfs" "nfs" "vboxsf" "glusterfs" "apfs" ];
        skipCheck = fs: fs.noCheck || fs.device == "none" || builtins.elem fs.fsType fsToSkipCheck;
        # https://wiki.archlinux.org/index.php/fstab#Filepath_spaces
        escape = string: builtins.replaceStrings [ " " "\t" ] [ "\\040" "\\011" ] string;
        swapOptions = sw: concatStringsSep "," (
          sw.options
          ++ optional (sw.priority != null) "pri=${toString sw.priority}"
          ++ optional (sw.discardPolicy != null) "discard${optionalString (sw.discardPolicy != "both") "=${toString sw.discardPolicy}"}"
        );
      in ''
        # This is a generated file.  Do not edit!
        #
        # To make changes, edit the fileSystems and swapDevices NixOS options
        # in your /etc/nixos/configuration.nix file.
        #
        # <file system> <mount point>   <type>  <options>       <dump>  <pass>

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
            "${sw.realDevice} none swap ${swapOptions sw}\n"
        )}
      '';

    # Provide a target that pulls in all filesystems.
    systemd.targets.fs =
      { description = "All File Systems";
        wants = [ "local-fs.target" "remote-fs.target" ];
      };

    systemd.services =

    # Emit systemd services to format requested filesystems.
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
            path = [ pkgs.util-linux ] ++ config.system.fsPackages;
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
      in listToAttrs (map formatDevice (filter (fs: fs.autoFormat) fileSystems)) // {
    # Mount /sys/fs/pstore for evacuating panic logs and crashdumps from persistent storage onto the disk using systemd-pstore.
    # This cannot be done with the other special filesystems because the pstore module (which creates the mount point) is not loaded then.
        "mount-pstore" = {
          serviceConfig = {
            Type = "oneshot";
            # skip on kernels without the pstore module
            ExecCondition = "${pkgs.kmod}/bin/modprobe -b pstore";
            ExecStart = pkgs.writeShellScript "mount-pstore.sh" ''
              set -eu
              # if the pstore module is builtin it will have mounted the persistent store automatically. it may also be already mounted for other reasons.
              ${pkgs.util-linux}/bin/mountpoint -q /sys/fs/pstore || ${pkgs.util-linux}/bin/mount -t pstore -o nosuid,noexec,nodev pstore /sys/fs/pstore
              # wait up to 1.5 seconds for the backend to be registered and the files to appear. a systemd path unit cannot detect this happening; and succeeding after a restart would not start dependent units.
              TRIES=15
              while [ "$(cat /sys/module/pstore/parameters/backend)" = "(null)" ]; do
                if (( $TRIES )); then
                  sleep 0.1
                  TRIES=$((TRIES-1))
                else
                  echo "Persistent Storage backend was not registered in time." >&2
                  break
                fi
              done
            '';
            RemainAfterExit = true;
          };
          unitConfig = {
            ConditionVirtualization = "!container";
            DefaultDependencies = false; # needed to prevent a cycle
          };
          before = [ "systemd-pstore.service" ];
          wantedBy = [ "systemd-pstore.service" ];
        };
      };

    systemd.tmpfiles.rules = [
      "d /run/keys 0750 root ${toString config.ids.gids.keys}"
      "z /run/keys 0750 root ${toString config.ids.gids.keys}"
    ];

    # Sync mount options with systemd's src/core/mount-setup.c: mount_table.
    boot.specialFileSystems = {
      "/proc" = { fsType = "proc"; options = [ "nosuid" "noexec" "nodev" ]; };
      "/run" = { fsType = "tmpfs"; options = [ "nosuid" "nodev" "strictatime" "mode=755" "size=${config.boot.runSize}" ]; };
      "/dev" = { fsType = "devtmpfs"; options = [ "nosuid" "strictatime" "mode=755" "size=${config.boot.devSize}" ]; };
      "/dev/shm" = { fsType = "tmpfs"; options = [ "nosuid" "nodev" "strictatime" "mode=1777" "size=${config.boot.devShmSize}" ]; };
      "/dev/pts" = { fsType = "devpts"; options = [ "nosuid" "noexec" "mode=620" "ptmxmode=0666" "gid=${toString config.ids.gids.tty}" ]; };

      # To hold secrets that shouldn't be written to disk
      "/run/keys" = { fsType = "ramfs"; options = [ "nosuid" "nodev" "mode=750" ]; };
    } // optionalAttrs (!config.boot.isContainer) {
      # systemd-nspawn populates /sys by itself, and remounting it causes all
      # kinds of weird issues (most noticeably, waiting for host disk device
      # nodes).
      "/sys" = { fsType = "sysfs"; options = [ "nosuid" "noexec" "nodev" ]; };
    };

  };

}
