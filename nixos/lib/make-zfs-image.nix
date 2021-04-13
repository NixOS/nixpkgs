{ lib
, pkgs
, # The NixOS configuration to be installed onto the disk image.
  config

, # The size of the root disk, in megabytes.
  rootSize ? 2048

, # The name of the ZFS pool
  bootPoolName ? "boot"

, # size of the boot disk
  bootSize ? 1024
, # features on the boot pool
  # Note: the pool has no features enabled by default,
  # and only this list of features is enabled. This list
  # must match GRUB's supported list.
  # See: https://github.com/openzfs/openzfs-docs/blame/master/docs/Getting%20Started/Debian/Debian%20Stretch%20Root%20on%20ZFS.rst#L200-L216
  bootPoolFeatures ? [
    "async_destroy"
    "bookmarks"
    "embedded_data"
    "empty_bpobj"
    "enabled_txg"
    "extensible_dataset"
    "filesystem_limits"
    "hole_birth"
    "large_blocks"
    "lz4_compress"
    "spacemap_histogram"
    "userobj_accounting"
  ]

, # zpool properties
  bootPoolProperties ? {
    autoexpand = "on";
  }
, # pool-wide filesystem properties
  bootPoolFilesystemProperties ? {
    acltype = "posixacl";
    atime = "off";
    compression = "on";
    mountpoint = "legacy";
    xattr = "sa";
  }
, # The name of the ZFS pool
  rootPoolName ? "tank"

, # zpool properties
  rootPoolProperties ? {
    autoexpand = "on";
  }
, # pool-wide filesystem properties
  rootPoolFilesystemProperties ? {
    acltype = "posixacl";
    atime = "off";
    compression = "on";
    mountpoint = "legacy";
    xattr = "sa";
  }

, # datasets, with per-attribute options:
  # mount: (optional) mount point in the VM
  # properties: (optional) ZFS properties on the dataset, like filesystemProperties
  # Note: datasets will be created from shorter to longer names as a simple topo-sort
  datasets ? {
    "system/root".mount = "/";
    "system/var".mount = "/var";
    "local/nix".mount = "/nix";
    "user/home".mount = "/home";
  }

, # The files and directories to be placed in the target file system.
  # This is a list of attribute sets {source, target} where `source'
  # is the file system object (regular file or directory) to be
  # grafted in the file system at path `target'.
  contents ? []

, # The initial NixOS configuration file to be copied to
  # /etc/nixos/configuration.nix. This configuration will be embedded
  # inside a configuration which includes the described ZFS fileSystems.
  configFile ? null

, # Shell code executed after the VM has finished.
  postVM ? ""

, name ? "nixos-disk-image"

, # Disk image format, one of qcow2, qcow2-compressed, vdi, vpc, raw.
  format ? "raw"

, # Include a copy of Nixpkgs in the disk image
  includeChannel ? true
}:
let
  formatOpt = if format == "qcow2-compressed" then "qcow2" else format;

  compress = lib.optionalString (format == "qcow2-compressed") "-c";

  filenameSuffix = "." + {
    qcow2 = "qcow2";
    vdi = "vdi";
    vpc = "vhd";
    raw = "img";
  }.${formatOpt} or formatOpt;
  bootFilename = "nixos.boot${filenameSuffix}";
  rootFilename = "nixos.root${filenameSuffix}";

  # FIXME: merge with channel.nix / make-channel.nix.
  channelSources =
    let
      nixpkgs = lib.cleanSource pkgs.path;
    in
      pkgs.runCommand "nixos-${config.system.nixos.version}" {} ''
        mkdir -p $out
        cp -prd ${nixpkgs.outPath} $out/nixos
        chmod -R u+w $out/nixos
        if [ ! -e $out/nixos/nixpkgs ]; then
          ln -s . $out/nixos/nixpkgs
        fi
        rm -rf $out/nixos/.git
        echo -n ${config.system.nixos.versionSuffix} > $out/nixos/.version-suffix
      '';

  closureInfo = pkgs.closureInfo {
    rootPaths = [ config.system.build.toplevel ]
    ++ (lib.optional includeChannel channelSources);
  };

  modulesTree = pkgs.aggregateModules
    (with config.boot.kernelPackages; [ kernel zfs ]);

  tools = lib.makeBinPath (
    with pkgs; [
      config.system.build.nixos-enter
      config.system.build.nixos-install
      dosfstools
      e2fsprogs
      gptfdisk
      nix
      parted
      utillinux
      zfs
    ]
  );

  stringifyProperties = prefix: properties: lib.concatStringsSep " \\\n" (
    lib.mapAttrsToList
      (
        property: value: "${prefix} ${lib.escapeShellArg property}=${lib.escapeShellArg value}"
      )
      properties
  );

  featuresToProperties = features:
    lib.listToAttrs
      (builtins.map (feature: {
        name = "feature@${feature}";
        value = "enabled";
      }) features);

  createDatasets =
    let
      datasetlist = lib.mapAttrsToList lib.nameValuePair datasets;
      sorted = lib.sort (left: right: (lib.stringLength left.name) < (lib.stringLength right.name)) datasetlist;
      cmd = { name, value }:
        let
          properties = stringifyProperties "-o" (value.properties or {});
        in
          "zfs create -p ${properties} ${rootPoolName}/${name}";
    in
      lib.concatMapStringsSep "\n" cmd sorted;

  mountDatasets =
    let
      datasetlist = lib.mapAttrsToList lib.nameValuePair datasets;
      mounts = lib.filter ({ value, ... }: value ? "mount") datasetlist;
      sorted = lib.sort (left: right: (lib.stringLength left.value.mount) < (lib.stringLength right.value.mount)) datasetlist;
      cmd = { name, value }:
        ''
          mkdir -p /mnt/${lib.escapeShellArg value.mount}
          mount -t zfs ${rootPoolName}/${name} /mnt/${lib.escapeShellArg value.mount}
        '';
    in
      lib.concatMapStringsSep "\n" cmd sorted;

  unmountDatasets =
    let
      datasetlist = lib.mapAttrsToList lib.nameValuePair datasets;
      mounts = lib.filter ({ value, ... }: value ? "mount") datasetlist;
      sorted = lib.sort (left: right: (lib.stringLength left.value.mount) > (lib.stringLength right.value.mount)) datasetlist;
      cmd = { name, value }:
        ''
          umount /mnt/${lib.escapeShellArg value.mount}
        '';
    in
      lib.concatMapStringsSep "\n" cmd sorted;


  fileSystemsCfgFile =
    let
      mountable = lib.filterAttrs (_: value: value ? "mount") datasets;
    in
      pkgs.writeText "filesystem-config.nix"
        (
          "builtins.fromJSON ''" + (
            builtins.toJSON {
              fileSystems = lib.mapAttrs'
                (
                  dataset: attrs:
                    {
                      name = attrs.mount;
                      value = {
                        fsType = "zfs";
                        device = "${rootPoolName}/${dataset}";
                      };
                    }
                )
                mountable;
            }
          ) + "''"
        );

  mergedConfig =
    if configFile == null
    then fileSystemsCfgFile
    else
      pkgs.runCommand "configuration.nix" {}
        ''
          (
            echo '{ imports = ['
            printf "(%s)\n" "$(cat ${fileSystemsCfgFile})";
            printf "(%s)\n" "$(cat ${configFile})";
            echo ']; }'
          ) > $out
        '';

  image = (
    pkgs.vmTools.override {
      rootModules =
        [ "zfs" "9p" "9pnet_virtio" "virtio_pci" "virtio_blk" "rtc_cmos" ];
      kernel = modulesTree;
    }
  ).runInLinuxVM (
    pkgs.runCommand name
      {
        QEMU_OPTS = "-drive file=$bootDiskImage,if=virtio,cache=unsafe,werror=report"
         + " -drive file=$rootDiskImage,if=virtio,cache=unsafe,werror=report";
        preVM = ''
          PATH=$PATH:${pkgs.qemu_kvm}/bin
          mkdir $out
          bootDiskImage=boot.raw
          qemu-img create -f raw $bootDiskImage ${toString bootSize}M

          rootDiskImage=root.raw
          qemu-img create -f raw $rootDiskImage ${toString rootSize}M
        '';

        postVM = ''
          ${if formatOpt == "raw" then ''
          mv $bootDiskImage $out/${bootFilename}
          mv $rootDiskImage $out/${rootFilename}
        '' else ''
          ${pkgs.qemu}/bin/qemu-img convert -f raw -O ${formatOpt} ${compress} $bootDiskImage $out/${bootFilename}
          ${pkgs.qemu}/bin/qemu-img convert -f raw -O ${formatOpt} ${compress} $rootDiskImage $out/${rootFilename}
        ''}
          bootDiskImage=$out/${bootFilename}
          rootDiskImage=$out/${rootFilename}
          set -x
          ${postVM}
        '';
      } ''
      export PATH=${tools}:$PATH
      set -x

      cp -sv /dev/vda /dev/sda
      cp -sv /dev/vda /dev/xvda

      zpool create -d \
        ${stringifyProperties "  -o" bootPoolProperties} \
        ${stringifyProperties "  -o" (featuresToProperties bootPoolFeatures)} \
        ${stringifyProperties "  -O" bootPoolFilesystemProperties} \
        ${bootPoolName} /dev/vda
      sgdisk -a1 -n2:34:2047 -t2:EF02 /dev/vda
      parted --script /dev/vda -- print
      zfs create ${bootPoolName}/boot

      zpool create \
        ${stringifyProperties "  -o" rootPoolProperties} \
        ${stringifyProperties "  -O" rootPoolFilesystemProperties} \
        ${rootPoolName} /dev/vdb
      parted --script /dev/vdb -- print

      ${createDatasets}
      ${mountDatasets}

      mkdir -p /mnt/boot
      mount -t zfs boot/boot /mnt/boot

      mount

      # Install a configuration.nix
      mkdir -p /mnt/etc/nixos
      # `cat` so it is mutable on the fs
      cat ${mergedConfig} > /mnt/etc/nixos/configuration.nix

      export NIX_STATE_DIR=$TMPDIR/state
      nix-store --load-db < ${closureInfo}/registration

      echo copying toplevel
      time nix copy --no-check-sigs --to 'local?root=/mnt/' ${config.system.build.toplevel}

      ${lib.optionalString includeChannel ''
        echo copying channels
        time nix copy --no-check-sigs --to 'local?root=/mnt/' ${channelSources}
      ''}

      echo installing bootloader
      time nixos-install --root /mnt --no-root-passwd \
        --system ${config.system.build.toplevel} \
        --substituters " " ${lib.optionalString includeChannel "--channel ${channelSources}"}

      df -h
      umount /mnt/boot
      ${unmountDatasets}
      zpool export ${rootPoolName}
      zpool export ${bootPoolName}
    ''
  );
in
image
