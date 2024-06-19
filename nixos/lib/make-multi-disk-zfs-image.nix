# Note: This is a private API, internal to NixOS. Its interface is subject
# to change without notice.
#
# The result of this builder is two disk images:
#
#  * `boot` - a small disk formatted with FAT to be used for /boot. FAT is
#    chosen to support EFI.
#  * `root` - a larger disk with a zpool taking the entire disk.
#
# This two-disk approach is taken to satisfy ZFS's requirements for
# autoexpand.
#
# # Why doesn't autoexpand work with ZFS in a partition?
#
# When ZFS owns the whole disk doesn’t really use a partition: it has
# a marker partition at the start and a marker partition at the end of
# the disk.
#
# If ZFS is constrained to a partition, ZFS leaves expanding the partition
# up to the user. Obviously, the user may not choose to do so.
#
# Once the user expands the partition, calling zpool online -e expands the
# vdev to use the whole partition. It doesn’t happen automatically
# presumably because zed doesn’t get an event saying it’s partition grew,
# whereas it can and does get an event saying the whole disk it is on is
# now larger.
{ lib
, pkgs
, # The NixOS configuration to be installed onto the disk image.
  config

, # size of the FAT boot disk, in megabytes.
  bootSize ? 1024

, # The size of the root disk, in megabytes.
  rootSize ? 2048

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
  # Notes:
  # 1. datasets will be created from shorter to longer names as a simple topo-sort
  # 2. you should define a root's dataset's mount for `/`
  datasets ? { }

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

, # Guest memory size
  memSize ? 1024

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
      util-linux
      zfs
    ]
  );

  hasDefinedMount  = disk: ((disk.mount or null) != null);

  stringifyProperties = prefix: properties: lib.concatStringsSep " \\\n" (
    lib.mapAttrsToList
      (
        property: value: "${prefix} ${lib.escapeShellArg property}=${lib.escapeShellArg value}"
      )
      properties
  );

  createDatasets =
    let
      datasetlist = lib.mapAttrsToList lib.nameValuePair datasets;
      sorted = lib.sort (left: right: (lib.stringLength left.name) < (lib.stringLength right.name)) datasetlist;
      cmd = { name, value }:
        let
          properties = stringifyProperties "-o" (value.properties or {});
        in
          "zfs create -p ${properties} ${name}";
    in
      lib.concatMapStringsSep "\n" cmd sorted;

  mountDatasets =
    let
      datasetlist = lib.mapAttrsToList lib.nameValuePair datasets;
      mounts = lib.filter ({ value, ... }: hasDefinedMount value) datasetlist;
      sorted = lib.sort (left: right: (lib.stringLength left.value.mount) < (lib.stringLength right.value.mount)) mounts;
      cmd = { name, value }:
        ''
          mkdir -p /mnt${lib.escapeShellArg value.mount}
          mount -t zfs ${name} /mnt${lib.escapeShellArg value.mount}
        '';
    in
      lib.concatMapStringsSep "\n" cmd sorted;

  unmountDatasets =
    let
      datasetlist = lib.mapAttrsToList lib.nameValuePair datasets;
      mounts = lib.filter ({ value, ... }: hasDefinedMount value) datasetlist;
      sorted = lib.sort (left: right: (lib.stringLength left.value.mount) > (lib.stringLength right.value.mount)) mounts;
      cmd = { name, value }:
        ''
          umount /mnt${lib.escapeShellArg value.mount}
        '';
    in
      lib.concatMapStringsSep "\n" cmd sorted;


  fileSystemsCfgFile =
    let
      mountable = lib.filterAttrs (_: value: hasDefinedMount value) datasets;
    in
      pkgs.runCommand "filesystem-config.nix" {
        buildInputs = with pkgs; [ jq nixpkgs-fmt ];
        filesystems = builtins.toJSON {
          fileSystems = lib.mapAttrs'
            (
              dataset: attrs:
                {
                  name = attrs.mount;
                  value = {
                    fsType = "zfs";
                    device = "${dataset}";
                  };
                }
            )
            mountable;
        };
        passAsFile = [ "filesystems" ];
      } ''
      (
        echo "builtins.fromJSON '''"
        jq . < "$filesystemsPath"
        echo "'''"
      ) > $out

      nixpkgs-fmt $out
    '';

  mergedConfig =
    if configFile == null
    then fileSystemsCfgFile
    else
      pkgs.runCommand "configuration.nix" {
        buildInputs = with pkgs; [ nixpkgs-fmt ];
      }
        ''
          (
            echo '{ imports = ['
            printf "(%s)\n" "$(cat ${fileSystemsCfgFile})";
            printf "(%s)\n" "$(cat ${configFile})";
            echo ']; }'
          ) > $out

          nixpkgs-fmt $out
        '';

  image = (
    pkgs.vmTools.override {
      rootModules =
        [ "zfs" "9p" "9pnet_virtio" "virtio_pci" "virtio_blk" ] ++
          (pkgs.lib.optional pkgs.stdenv.hostPlatform.isx86 "rtc_cmos");
      kernel = modulesTree;
    }
  ).runInLinuxVM (
    pkgs.runCommand name
      {
        QEMU_OPTS = "-drive file=$bootDiskImage,if=virtio,cache=unsafe,werror=report"
         + " -drive file=$rootDiskImage,if=virtio,cache=unsafe,werror=report";
         inherit memSize;
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
          ${pkgs.qemu_kvm}/bin/qemu-img convert -f raw -O ${formatOpt} ${compress} $bootDiskImage $out/${bootFilename}
          ${pkgs.qemu_kvm}/bin/qemu-img convert -f raw -O ${formatOpt} ${compress} $rootDiskImage $out/${rootFilename}
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

      parted --script /dev/vda -- \
        mklabel gpt \
        mkpart no-fs 1MiB 2MiB \
        set 1 bios_grub on \
        align-check optimal 1 \
        mkpart ESP fat32 2MiB -1MiB \
        align-check optimal 2 \
        print

      sfdisk --dump /dev/vda


      zpool create \
        ${stringifyProperties "  -o" rootPoolProperties} \
        ${stringifyProperties "  -O" rootPoolFilesystemProperties} \
        ${rootPoolName} /dev/vdb
      parted --script /dev/vdb -- print

      ${createDatasets}
      ${mountDatasets}

      mkdir -p /mnt/boot
      mkfs.vfat -n ESP /dev/vda2
      mount /dev/vda2 /mnt/boot

      mount

      # Install a configuration.nix
      mkdir -p /mnt/etc/nixos
      # `cat` so it is mutable on the fs
      cat ${mergedConfig} > /mnt/etc/nixos/configuration.nix

      export NIX_STATE_DIR=$TMPDIR/state
      nix-store --load-db < ${closureInfo}/registration

      nixos-install \
        --root /mnt \
        --no-root-passwd \
        --system ${config.system.build.toplevel} \
        --substituters "" \
        ${lib.optionalString includeChannel ''--channel ${channelSources}''}

      df -h

      umount /mnt/boot
      ${unmountDatasets}

      zpool export ${rootPoolName}
    ''
  );
in
image
