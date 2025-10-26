{
  config,
  lib,
  pkgs,
  utils,
  ...
}@moduleArgs:
let
  inherit (lib)
    any
    attrValues
    concatMapStrings
    concatMapStringsSep
    concatStringsSep
    elem
    filter
    flip
    head
    literalExpression
    mkDefault
    mkEnableOption
    mkIf
    mkMerge
    mkOption
    optional
    optionalAttrs
    optionalString
    toposort
    types
    ;
  inherit (utils) fsBefore;

  # https://wiki.archlinux.org/index.php/fstab#Filepath_spaces
  escape = string: builtins.replaceStrings [ " " "\t" ] [ "\\040" "\\011" ] string;

  # A list of attrnames is coerced into an attrset of bools by
  # setting the values to true.
  attrNamesToTrue = types.coercedTo (types.listOf types.str) (
    enabledList: lib.genAttrs enabledList (_attrName: true)
  ) (types.attrsOf types.bool);

  addCheckDesc =
    desc: elemType: check:
    types.addCheck elemType check // { description = "${elemType.description} (with check: ${desc})"; };

  isNonEmpty = s: (builtins.match "[ \t\n]*" s) == null;
  nonEmptyStr = addCheckDesc "non-empty" types.str isNonEmpty;

  fileSystems' = toposort fsBefore (attrValues config.fileSystems);

  fileSystems =
    if fileSystems' ? result then
      # use topologically sorted fileSystems everywhere
      fileSystems'.result
    else
      # the assertion below will catch this,
      # but we fall back to the original order
      # anyway so that other modules could check
      # their assertions too
      (attrValues config.fileSystems);

  specialFSTypes = [
    "proc"
    "sysfs"
    "tmpfs"
    "ramfs"
    "devtmpfs"
    "devpts"
  ];

  nonEmptyWithoutTrailingSlash = addCheckDesc "non-empty without trailing slash" types.str (
    s: isNonEmpty s && (builtins.match ".+/" s) == null
  );

  coreFileSystemOpts =
    { name, config, ... }:
    {

      options = {
        enable = mkEnableOption "the filesystem mount" // {
          default = true;
        };

        mountPoint = mkOption {
          example = "/mnt/usb";
          type = nonEmptyWithoutTrailingSlash;
          default = name;
          description = ''
            Location where the file system will be mounted.

            This is called `mountpoint` in {manpage}`mount(8)` and `fs_file` in {manpage}`fstab(5)`
          '';
        };

        stratis.poolUuid = mkOption {
          type = types.uniq (types.nullOr types.str);
          description = ''
            UUID of the stratis pool that the fs is located in

            This is only relevant if you are using [stratis](https://stratis-storage.github.io/).
          '';
          example = "04c68063-90a5-4235-b9dd-6180098a20d9";
          default = null;
        };

        device = mkOption {
          default = null;
          example = "/dev/sda";
          type = types.nullOr nonEmptyStr;
          description = ''
            The device as passed to `mount`.

            This can be any of:

            - a filename of a block special device such as `/dev/sdc3`
            - a tag such as `UUID=fdd68895-c307-4549-8c9c-90e44c71f5b7`
            - (for bind mounts only) the source path
            - something else depending on the {option}`fsType`. For example, `nfs` device may look like `knuth.cwi.nl:/dir`

            This is called `device` in {manpage}`mount(8)` and `fs_spec` in {manpage}`fstab(5)`.
          '';
        };

        fsType = mkOption {
          default = "auto";
          example = "ext3";
          type = nonEmptyStr;
          description = ''
            Type of the file system.

            This is the `fstype` passed to `-t` in the {manpage}`mount(8)` command, and is called `fs_vfstype` in {manpage}`fstab(5)`.
          '';
        };

        options = mkOption {
          default = [ "defaults" ];
          example = [ "data=journal" ];
          description = ''
            Options used to mount the file system.

            This is called `options` in {manpage}`mount(8)` and `fs_mntops` in {manpage}`fstab(5)`

            Some options that can be used for all mounts are documented in {manpage}`mount(8)` under `FILESYSTEM-INDEPENDENT MOUNT OPTIONS`.

            Options that systemd understands are documented in {manpage}`systemd.mount(5)` under `FSTAB`.

            Each filesystem supports additional options, see the docs for that filesystem.
          '';
          type = types.nonEmptyListOf nonEmptyStr;
        };

        depends = mkOption {
          default = [ ];
          example = [ "/persist" ];
          type = types.listOf nonEmptyWithoutTrailingSlash;
          description = ''
            List of paths that should be mounted before this one. This filesystem's
            {option}`device` and {option}`mountPoint` are always
            checked and do not need to be included explicitly. If a path is added
            to this list, any other filesystem whose mount point is a parent of
            the path will be mounted before this filesystem. The paths do not need
            to actually be the {option}`mountPoint` of some other filesystem.

            This is useful for mounts which require keys and/or configuration files residing on another filesystem.
          '';
        };

      };

      config = {
        device = mkIf (elem config.fsType specialFSTypes) (mkDefault config.fsType);
      };

    };

  fileSystemOpts =
    { config, ... }:
    {

      options = {

        label = mkOption {
          default = null;
          example = "root-partition";
          type = types.nullOr nonEmptyStr;
          description = ''
            Label of the device. This simply sets {option}`device` to
            `/dev/disk/by-id/''${label}`. Note that devices will not
            have a label unless they contain a filesystem which
            supports labels, such as ext4 or fat32.
          '';
        };

        autoFormat = mkOption {
          default = false;
          type = types.bool;
          description = ''
            If the device does not currently contain a filesystem (as
            determined by {command}`blkid`), then automatically
            format it with the filesystem type specified in
            {option}`fsType`.  Use with caution.
          '';
        };

        formatOptions = mkOption {
          visible = false;
          type = types.unspecified;
          default = null;
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

      config.device = mkIf (config.label != null) (mkDefault "/dev/disk/by-label/${escape config.label}");

      config.options =
        let
          inInitrd = utils.fsNeededForBoot config;
        in
        mkMerge [
          (mkIf config.autoResize [ "x-systemd.growfs" ])
          (mkIf config.autoFormat [ "x-systemd.makefs" ])
          (mkIf (utils.fsNeededForBoot config) [ "x-initrd.mount" ])
          (mkIf
            # With scripted stage 1, depends is implemented by sorting 'config.system.build.fileSystems'
            (config.depends != [ ] && (inInitrd -> moduleArgs.config.boot.initrd.systemd.enable))
            (map (x: "x-systemd.requires-mounts-for=${optionalString inInitrd "/sysroot"}${x}") config.depends)
          )
        ];

    };

  # Makes sequence of `specialMount device mountPoint options fsType` commands.
  # `systemMount` should be defined in the sourcing script.
  makeSpecialMounts =
    mounts:
    pkgs.writeText "mounts.sh" (
      concatMapStringsSep "\n" (mount: ''
        specialMount "${mount.device}" "${mount.mountPoint}" "${concatStringsSep "," mount.options}" "${mount.fsType}"
      '') mounts
    );

  makeFstabEntries =
    let
      fsToSkipCheck = [
        "none"
        "auto"
        "overlay"
        "iso9660"
        "bindfs"
        "udf"
        "btrfs"
        "zfs"
        "tmpfs"
        "bcachefs"
        "nfs"
        "nfs4"
        "nilfs2"
        "vboxsf"
        "squashfs"
        "glusterfs"
        "apfs"
        "9p"
        "cifs"
        "prl_fs"
        "vmhgfs"
      ]
      ++ lib.optionals (!config.boot.initrd.checkJournalingFS) [
        "ext3"
        "ext4"
        "reiserfs"
        "xfs"
        "jfs"
        "f2fs"
      ];
      isBindMount = fs: builtins.elem "bind" fs.options;
      skipCheck =
        fs: fs.noCheck || fs.device == "none" || builtins.elem fs.fsType fsToSkipCheck || isBindMount fs;
    in
    fstabFileSystems:
    { }:
    concatMapStrings (
      fs:
      (
        if fs.device != null then
          escape fs.device
        else
          throw "No device specified for mount point ‘${fs.mountPoint}’."
      )
      + " "
      + escape fs.mountPoint
      + " "
      + fs.fsType
      + " "
      + escape (builtins.concatStringsSep "," fs.options)
      + " 0 "
      + (
        if skipCheck fs then
          "0"
        else if fs.mountPoint == "/" then
          "1"
        else
          "2"
      )
      + "\n"
    ) fstabFileSystems;

  initrdFstab = pkgs.writeText "initrd-fstab" (
    makeFstabEntries (filter utils.fsNeededForBoot fileSystems) { }
  );

in

{

  ###### interface

  options = {

    fileSystems = mkOption {
      default = { };
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
      type = types.attrsOf (
        types.submodule [
          coreFileSystemOpts
          fileSystemOpts
        ]
      );
      apply = lib.filterAttrs (_: fs: fs.enable);
      description = ''
        The file systems to be mounted.  It must include an entry for
        the root directory (`mountPoint = "/"`).  Each
        entry in the list is an attribute set with the following fields:
        `mountPoint`, `device`,
        `fsType` (a file system type recognised by
        {command}`mount`; defaults to
        `"auto"`), and `options`
        (the mount options passed to {command}`mount` using the
        {option}`-o` flag; defaults to `[ "defaults" ]`).

        Instead of specifying `device`, you can also
        specify a volume label (`label`) for file
        systems that support it, such as ext2/ext3 (see {command}`mke2fs -L`).
      '';
    };

    system.fsPackages = mkOption {
      internal = true;
      default = [ ];
      description = "Packages supplying file system mounters and checkers.";
    };

    boot.supportedFilesystems = mkOption {
      default = { };
      example = literalExpression ''
        {
          btrfs = true;
          zfs = lib.mkForce false;
        }
      '';
      type = attrNamesToTrue;
      description = ''
        Names of supported filesystem types, or an attribute set of file system types
        and their state. The set form may be used together with `lib.mkForce` to
        explicitly disable support for specific filesystems, e.g. to disable ZFS
        with an unsupported kernel.
      '';
    };

    boot.specialFileSystems = mkOption {
      default = { };
      type = types.attrsOf (types.submodule coreFileSystemOpts);
      apply = lib.filterAttrs (_: fs: fs.enable);
      internal = true;
      description = ''
        Special filesystems that are mounted very early during boot.
      '';
    };

    boot.devSize = mkOption {
      default = "5%";
      example = "32m";
      type = types.str;
      description = ''
        Size limit for the /dev tmpfs. Look at {manpage}`mount(8)`, tmpfs size option,
        for the accepted syntax.
      '';
    };

    boot.devShmSize = mkOption {
      default = "50%";
      example = "256m";
      type = types.str;
      description = ''
        Size limit for the /dev/shm tmpfs. Look at {manpage}`mount(8)`, tmpfs size option,
        for the accepted syntax.
      '';
    };

    boot.runSize = mkOption {
      default = "25%";
      example = "256m";
      type = types.str;
      description = ''
        Size limit for the /run tmpfs. Look at {manpage}`mount(8)`, tmpfs size option,
        for the accepted syntax.
      '';
    };
  };

  ###### implementation

  config = {

    assertions =
      let
        ls = sep: concatMapStringsSep sep (x: x.mountPoint);
        resizableFSes = [
          "ext3"
          "ext4"
          "btrfs"
          "xfs"
        ];
        notAutoResizable = fs: fs.autoResize && !(builtins.elem fs.fsType resizableFSes);
      in
      [
        {
          assertion = !(fileSystems' ? cycle);
          message = "The ‘fileSystems’ option can't be topologically sorted: mountpoint dependency path ${ls " -> " fileSystems'.cycle} loops to ${ls ", " fileSystems'.loops}";
        }
        {
          assertion = !(any notAutoResizable fileSystems);
          message =
            let
              fs = head (filter notAutoResizable fileSystems);
            in
            ''
              Mountpoint '${fs.mountPoint}': 'autoResize = true' is not supported for 'fsType = "${fs.fsType}"'
              ${optionalString (fs.fsType == "auto") "fsType has to be explicitly set and"}
              only the following support it: ${lib.concatStringsSep ", " resizableFSes}.
            '';
        }
        {
          assertion = !(any (fs: fs.formatOptions != null) fileSystems);
          message = ''
            'fileSystems.<name>.formatOptions' has been removed, since
            systemd-makefs does not support any way to provide formatting
            options.
          '';
        }
      ]
      ++ lib.map (fs: {
        assertion = fs.label != null -> fs.device == "/dev/disk/by-label/${escape fs.label}";
        message = ''
          The filesystem with mount point ${fs.mountPoint} has its label and device set to inconsistent values:
            label: ${toString fs.label}
            device: ${toString fs.device}
          'filesystems.<name>.label' and 'filesystems.<name>.device' are mutually exclusive. Please set only one.
        '';
      }) fileSystems;

    # Export for use in other modules
    system.build.fileSystems = fileSystems;
    system.build.earlyMountScript = makeSpecialMounts (toposort fsBefore (
      attrValues config.boot.specialFileSystems
    )).result;

    boot.supportedFilesystems = map (fs: fs.fsType) fileSystems;

    # Add the mount helpers to the system path so that `mount' can find them.
    system.fsPackages = [ pkgs.dosfstools ];

    environment.systemPackages = config.system.fsPackages;

    environment.etc.fstab.text =
      let
        swapOptions =
          sw:
          concatStringsSep "," (
            sw.options
            ++ optional (sw.priority != null) "pri=${toString sw.priority}"
            ++
              optional (sw.discardPolicy != null)
                "discard${optionalString (sw.discardPolicy != "both") "=${toString sw.discardPolicy}"}"
          );
      in
      ''
        # This is a generated file.  Do not edit!
        #
        # To make changes, edit the fileSystems and swapDevices NixOS options
        # in your /etc/nixos/configuration.nix file.
        #
        # <file system> <mount point>   <type>  <options>       <dump>  <pass>

        # Filesystems.
        ${makeFstabEntries fileSystems { }}

        ${optionalString (config.swapDevices != [ ]) "# Swap devices."}
        ${flip concatMapStrings config.swapDevices (sw: "${sw.realDevice} none swap ${swapOptions sw}\n")}
      '';

    boot.initrd.systemd.storePaths = [ initrdFstab ];
    boot.initrd.systemd.managerEnvironment.SYSTEMD_SYSROOT_FSTAB = initrdFstab;
    boot.initrd.systemd.services.initrd-parse-etc.environment.SYSTEMD_SYSROOT_FSTAB = initrdFstab;

    # Provide a target that pulls in all filesystems.
    systemd.targets.fs = {
      description = "All File Systems";
      wants = [
        "local-fs.target"
        "remote-fs.target"
      ];
    };

    systemd.tmpfiles.rules = [
      "d /run/keys 0750 root ${toString config.ids.gids.keys}"
      "z /run/keys 0750 root ${toString config.ids.gids.keys}"
    ];

    # Sync mount options with systemd's src/core/mount-setup.c: mount_table.
    boot.specialFileSystems = {
      # To hold secrets that shouldn't be written to disk
      "/run/keys" = {
        fsType = "ramfs";
        options = [
          "nosuid"
          "nodev"
          "mode=750"
        ];
      };
    }
    // optionalAttrs (!config.boot.isContainer) {
      # systemd-nspawn populates /sys by itself, and remounting it causes all
      # kinds of weird issues (most noticeably, waiting for host disk device
      # nodes).
      "/sys" = {
        fsType = "sysfs";
        options = [
          "nosuid"
          "noexec"
          "nodev"
        ];
      };
    }
    // optionalAttrs (!config.boot.isNspawnContainer) {
      "/proc" = {
        fsType = "proc";
        options = [
          "nosuid"
          "noexec"
          "nodev"
        ];
      };
      "/run" = {
        fsType = "tmpfs";
        options = [
          "nosuid"
          "nodev"
          "strictatime"
          "mode=755"
          "size=${config.boot.runSize}"
        ];
      };
      "/dev" = {
        fsType = "devtmpfs";
        options = [
          "nosuid"
          "strictatime"
          "mode=755"
          "size=${config.boot.devSize}"
        ];
      };
      "/dev/shm" = {
        fsType = "tmpfs";
        options = [
          "nosuid"
          "nodev"
          "strictatime"
          "mode=1777"
          "size=${config.boot.devShmSize}"
        ];
      };
      "/dev/pts" = {
        fsType = "devpts";
        options = [
          "nosuid"
          "noexec"
          "mode=620"
          "ptmxmode=0666"
          "gid=${toString config.ids.gids.tty}"
        ];
      };
    };

  };

}
