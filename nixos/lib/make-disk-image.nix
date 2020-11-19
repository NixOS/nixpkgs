{ pkgs
, lib

, # The NixOS configuration to be installed onto the disk image.
  config

, # The size of the disk, in megabytes.
  # if "auto" size is calculated based on the contents copied to it and
  #   additionalSpace is taken into account.
  diskSize ? "auto"

, # additional disk space to be added to the image if diskSize "auto"
  # is used
  additionalSpace ? "512M"

, # size of the boot partition, is only used if partitionTableType is
  # either "efi" or "hybrid"
  bootSize ? "256M"

, # The files and directories to be placed in the target file system.
  # This is a list of attribute sets {source, target} where `source'
  # is the file system object (regular file or directory) to be
  # grafted in the file system at path `target'.
  contents ? []

, # Type of partition table to use; either "legacy", "efi", or "none".
  # For "efi" images, the GPT partition table is used and a mandatory ESP
  #   partition of reasonable size is created in addition to the root partition.
  # For "legacy", the msdos partition table is used and a single large root
  #   partition is created.
  # For "legacy+gpt", the GPT partition table is used, a 1MiB no-fs partition for
  #   use by the bootloader is created, and a single large root partition is
  #   created.
  # For "hybrid", the GPT partition table is used and a mandatory ESP
  #   partition of reasonable size is created in addition to the root partition.
  #   Also a legacy MBR will be present.
  # For "none", no partition table is created. Enabling `installBootLoader`
  #   most likely fails as GRUB will probably refuse to install.
  partitionTableType ? "legacy"

, # The root file system type.
  fsType ? "ext4"

, # Filesystem label
  label ? "nixos"

, # The initial NixOS configuration file to be copied to
  # /etc/nixos/configuration.nix.
  configFile ? null

, # Shell code executed after the VM has finished.
  postVM ? ""

, name ? "nixos-disk-image"

, # Disk image format, one of qcow2, qcow2-compressed, vdi, vpc, raw.
  format ? "raw"
}:

assert partitionTableType == "legacy" || partitionTableType == "legacy+gpt" || partitionTableType == "efi" || partitionTableType == "hybrid" || partitionTableType == "none";
# We use -E offset=X below, which is only supported by e2fsprogs
assert partitionTableType != "none" -> fsType == "ext4";

with lib;

let format' = format; in let

  format = if format' == "qcow2-compressed" then "qcow2" else format';

  compress = optionalString (format' == "qcow2-compressed") "-c";

  filename = "nixos." + {
    qcow2 = "qcow2";
    vdi   = "vdi";
    vpc   = "vhd";
    raw   = "img";
  }.${format} or format;

  rootPartition = { # switch-case
    legacy = "1";
    "legacy+gpt" = "2";
    efi = "2";
    hybrid = "3";
  }.${partitionTableType};

  partitionDiskScript = { # switch-case
    legacy = ''
      parted --script $diskImage -- \
        mklabel msdos \
        mkpart primary ext4 1MiB -1
    '';
    "legacy+gpt" = ''
      parted --script $diskImage -- \
        mklabel gpt \
        mkpart no-fs 1MB 2MB \
        set 1 bios_grub on \
        align-check optimal 1 \
        mkpart primary ext4 2MB -1 \
        align-check optimal 2 \
        print
    '';
    efi = ''
      parted --script $diskImage -- \
        mklabel gpt \
        mkpart ESP fat32 8MiB ${bootSize} \
        set 1 boot on \
        mkpart primary ext4 ${bootSize} -1
    '';
    hybrid = ''
      parted --script $diskImage -- \
        mklabel gpt \
        mkpart ESP fat32 8MiB ${bootSize} \
        set 1 boot on \
        mkpart no-fs 0 1024KiB \
        set 2 bios_grub on \
        mkpart primary ext4 ${bootSize} -1
    '';
    none = "";
  }.${partitionTableType};

  nixpkgs = cleanSource pkgs.path;

  # FIXME: merge with channel.nix / make-channel.nix.
  channelSources = pkgs.runCommand "nixos-${config.system.nixos.version}" {} ''
    mkdir -p $out
    cp -prd ${nixpkgs.outPath} $out/nixos
    chmod -R u+w $out/nixos
    if [ ! -e $out/nixos/nixpkgs ]; then
      ln -s . $out/nixos/nixpkgs
    fi
    rm -rf $out/nixos/.git
    echo -n ${config.system.nixos.versionSuffix} > $out/nixos/.version-suffix
  '';

  binPath = with pkgs; makeBinPath (
    [ rsync
      utillinux
      parted
      e2fsprogs
      lkl
      config.system.build.nixos-install
      config.system.build.nixos-enter
      nix
    ] ++ stdenv.initialPath);

  # I'm preserving the line below because I'm going to search for it across nixpkgs to consolidate
  # image building logic. The comment right below this now appears in 4 different places in nixpkgs :)
  # !!! should use XML.
  sources = map (x: x.source) contents;
  targets = map (x: x.target) contents;

  closureInfo = pkgs.closureInfo { rootPaths = [ config.system.build.toplevel channelSources ]; };

  prepareImage = ''
    export PATH=${binPath}

    # Yes, mkfs.ext4 takes different units in different contexts. Fun.
    sectorsToKilobytes() {
      echo $(( ( "$1" * 512 ) / 1024 ))
    }

    sectorsToBytes() {
      echo $(( "$1" * 512  ))
    }

    mkdir $out

    root="$PWD/root"
    mkdir -p $root

    # Copy arbitrary other files into the image
    # Semi-shamelessly copied from make-etc.sh. I (@copumpkin) shall factor this stuff out as part of
    # https://github.com/NixOS/nixpkgs/issues/23052.
    set -f
    sources_=(${concatStringsSep " " sources})
    targets_=(${concatStringsSep " " targets})
    set +f

    for ((i = 0; i < ''${#targets_[@]}; i++)); do
      source="''${sources_[$i]}"
      target="''${targets_[$i]}"

      if [[ "$source" =~ '*' ]]; then
        # If the source name contains '*', perform globbing.
        mkdir -p $root/$target
        for fn in $source; do
          rsync -a --no-o --no-g "$fn" $root/$target/
        done
      else
        mkdir -p $root/$(dirname $target)
        if ! [ -e $root/$target ]; then
          rsync -a --no-o --no-g $source $root/$target
        else
          echo "duplicate entry $target -> $source"
          exit 1
        fi
      fi
    done

    export HOME=$TMPDIR

    # Provide a Nix database so that nixos-install can copy closures.
    export NIX_STATE_DIR=$TMPDIR/state
    nix-store --load-db < ${closureInfo}/registration

    chmod 755 "$TMPDIR"
    echo "running nixos-install..."
    nixos-install --root $root --no-bootloader --no-root-passwd \
      --system ${config.system.build.toplevel} --channel ${channelSources} --substituters ""

    diskImage=nixos.raw

    ${if diskSize == "auto" then ''
      ${if partitionTableType == "efi" || partitionTableType == "hybrid" then ''
        additionalSpace=$(( ($(numfmt --from=iec '${additionalSpace}') + $(numfmt --from=iec '${bootSize}')) / 1000 ))
      '' else ''
        additionalSpace=$(( $(numfmt --from=iec '${additionalSpace}') / 1000 ))
      ''}
      diskSize=$(( $(set -- $(du -d0 $root); echo "$1") + $additionalSpace ))
      truncate -s "$diskSize"K $diskImage
    '' else ''
      truncate -s ${toString diskSize}M $diskImage
    ''}

    ${partitionDiskScript}

    ${if partitionTableType != "none" then ''
      # Get start & length of the root partition in sectors to $START and $SECTORS.
      eval $(partx $diskImage -o START,SECTORS --nr ${rootPartition} --pairs)

      mkfs.${fsType} -F -L ${label} $diskImage -E offset=$(sectorsToBytes $START) $(sectorsToKilobytes $SECTORS)K
    '' else ''
      mkfs.${fsType} -F -L ${label} $diskImage
    ''}

    echo "copying staging root to image..."
    cptofs -p ${optionalString (partitionTableType != "none") "-P ${rootPartition}"} -t ${fsType} -i $diskImage $root/* /
  '';
in pkgs.vmTools.runInLinuxVM (
  pkgs.runCommand name
    { preVM = prepareImage;
      buildInputs = with pkgs; [ utillinux e2fsprogs dosfstools ];
      postVM = ''
        ${if format == "raw" then ''
          mv $diskImage $out/${filename}
        '' else ''
          ${pkgs.qemu}/bin/qemu-img convert -f raw -O ${format} ${compress} $diskImage $out/${filename}
        ''}
        diskImage=$out/${filename}
        ${postVM}
      '';
      memSize = 1024;
    }
    ''
      export PATH=${binPath}:$PATH

      rootDisk=${if partitionTableType != "none" then "/dev/vda${rootPartition}" else "/dev/vda"}

      # Some tools assume these exist
      ln -s vda /dev/xvda
      ln -s vda /dev/sda

      mountPoint=/mnt
      mkdir $mountPoint
      mount $rootDisk $mountPoint

      # Create the ESP and mount it. Unlike e2fsprogs, mkfs.vfat doesn't support an
      # '-E offset=X' option, so we can't do this outside the VM.
      ${optionalString (partitionTableType == "efi" || partitionTableType == "hybrid") ''
        mkdir -p /mnt/boot
        mkfs.vfat -n ESP /dev/vda1
        mount /dev/vda1 /mnt/boot
      ''}

      # Install a configuration.nix
      mkdir -p /mnt/etc/nixos
      ${optionalString (configFile != null) ''
        cp ${configFile} /mnt/etc/nixos/configuration.nix
      ''}

      # Set up core system link, GRUB, etc.
      NIXOS_INSTALL_BOOTLOADER=1 nixos-enter --root $mountPoint -- /nix/var/nix/profiles/system/bin/switch-to-configuration boot

      # The above scripts will generate a random machine-id and we don't want to bake a single ID into all our images
      rm -f $mountPoint/etc/machine-id

      umount -R /mnt

      # Make sure resize2fs works. Note that resize2fs has stricter criteria for resizing than a normal
      # mount, so the `-c 0` and `-i 0` don't affect it. Setting it to `now` doesn't produce deterministic
      # output, of course, but we can fix that when/if we start making images deterministic.
      ${optionalString (fsType == "ext4") ''
        tune2fs -T now -c 0 -i 0 $rootDisk
      ''}
    ''
)
