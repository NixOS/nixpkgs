{ pkgs
, lib

, # The NixOS configuration to be installed onto the disk image.
  config

, # The size of the disk, in megabytes.
  # if "auto" size is calculated based on the contents copied to it and
  #   additionalSpace is taken into account.
  diskSize ? "auto"

, # Additional disk space to be added to the image if diskSize "auto"
  # is used.
  #
  # Can be specified as an integer or string ending in M/MB/MiB. The
  # value will be assumed to be MiB.
  additionalSpace ? 512

, # Size of the boot partition, is only used if partitionTableType is
  # either "efi" or "hybrid".
  #
  # This will be undersized slightly, as this is actually the offset of
  # the end of the partition. Generally it will be 1MiB smaller.
  #
  # Can be specified as an integer or string ending in M/MB/MiB. The
  # value will be assumed to be MiB.
  bootSize ? 256

, # Size of the swap partition, if one is desired. Set this to null if
  # you don't want a swap partition.
  #
  # Can be specified as an integer or string ending in M/MB/MiB. The
  # value will be assumed to be MiB.
  swapSize ? null

, # The files and directories to be placed in the target file system.
  # This is a list of attribute sets {source, target, mode, user, group} where
  # `source' is the file system object (regular file or directory) to be
  # grafted in the file system at path `target', `mode' is a string containing
  # the permissions that will be set (ex. "755"), `user' and `group' are the
  # user and group name that will be set as owner of the files.
  # `mode', `user', and `group' are optional.
  # When setting one of `user' or `group', the other needs to be set too.
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

, # The boot partition ID. Also used for the volume label for legacy disk labels.
  # This default magic value is "Nix!" in little endian and is the same as the SD card
  # builder.
  bootPartitionId ? "0x2178694e"

, # The boot UUID.
  bootUUID ? "44444444-4444-4444-8888-888888888886"

, # The boot filesystem label and partition name. Converted to uppercase for mkfs.msdos.
  bootLabel ? "efi"

, # The swapspace UUID.
  swapUUID ? "44444444-4444-4444-8888-888888888887"

, # The swapspace label and partition name.
  swapLabel ? "swap"

, # Root filesystem label and partition name.
  label ? "nixos"

, # The rootfs UUID, if applicable for fsType.
  uuid ? "44444444-4444-4444-8888-888888888888"

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
# Either both or none of {user,group} need to be set
assert lib.all
         (attrs: ((attrs.user  or null) == null)
              == ((attrs.group or null) == null))
         contents;

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

  swapPartitionNumber = { # switch-case
    legacy = 1;
    "legacy+gpt" = 2;
    efi = 2;
    hybrid = 3;
  }.${partitionTableType};
  swapPartition = toString swapPartitionNumber;

  rootPartitionNumber = if swapSize == null then swapPartitionNumber else swapPartitionNumber + 1;
  rootPartition = toString rootPartitionNumber;

  # Chops off M/MB/MiB suffixes.
  normalizeMiB = value: let
    # Assume that they meant "MiB" by "MB" or "M".
    regexMatch = builtins.match "^([[:digit:]]+)(M|MB|MiB)?$" value;
  in
    if regexMatch == null then throw "Invalid size: ${value}. Provide a string optionally ending in M/MB/MiB."
    else elemAt regexMatch 0;

  # Validates that the given size is positive.
  validateMiB = value:
    if value > 0 then value
    else throw "Size must be positive";

  # Converts a MiB string to an integer. If an integer is provided,
  # returns it directly if it represents a valid size.
  fromMiB = value:
    if isString value then toInt (normalizeMiB value)
    else if isInt value then validateMiB value
    else throw "Sizes must be integers or strings";

  # Converts an integer to a MiB string. If string is provided,
  # runs it through normalizeMiB and returns it suffixed with MiB.
  toMiB = value:
    if isInt value then "${toString (validateMiB value)}MiB"
    else if isString value then "${normalizeMiB value}MiB"
    else throw "Sizes must be integers or strings";

  # Additional size to add to the disk, taking into account the boot size
  # and swap size. Only used if the disk size is auto. Not necessarily 1 MiB
  # aligned.
  reservedSpaceBytes = let
    # One MiB in bytes.
    MiB = 1024 * 1024;

    # Reserved bytes for the GPT at the end of the disk.
    reservedEndGptBytes = 512 * 34;
  in
    (
      if partitionTableType == "efi" || partitionTableType == "hybrid" then
        # This is the offset of the end of the boot partition, as opposed to
        # the actual partition size
        (fromMiB bootSize) * MiB + reservedEndGptBytes
      else if partitionTableType == "legacy+gpt" then
        # no-fs boot partition ends at +2MiB
        2 * MiB + reservedEndGptBytes
      else if partitionTableType == "legacy" then
        # Next partition starts at +1MiB
        1 * MiB
      else
        0
    ) + (if swapSize == null then 0 else (fromMiB swapSize) * MiB);

  partitionDiskScript = { # switch-case
    legacy = ''
      parted --script $diskImage -- \
        mklabel msdos

      # We need to use fdisk to set the volume ID.
      echo "x i "${escapeShellArg bootPartitionId}" r w" | tr ' ' '\n' | fdisk $diskImage

      ${if swapSize == null then ''
        parted --script $diskImage -- \
          mkpart primary ext4 ${toMiB 2} -1
        '' else let swapEnd = 2 + (fromMiB swapSize); in ''
        parted --script $diskImage -- \
          mkpart primary linux-swap ${toMiB 2} ${toMiB swapEnd} \
          mkpart primary ext4 ${toMiB swapEnd} -1
        ''}
    '';
    "legacy+gpt" = ''
      parted --script $diskImage -- \
        mklabel gpt

      # We need to use gdisk to set the volume ID.
      echo "x g "${escapeShellArg bootUUID}" m w y" | tr ' ' '\n' | gdisk $diskImage

      parted --script $diskImage -- \
        mkpart no-fs ${toMiB 1} ${toMiB 2} \
        set 1 bios_grub on \
        align-check optimal 1

      ${if swapSize == null then ''
        parted --script $diskImage -- \
          mkpart ${escapeShellArg label} ext4 ${toMiB 2} -1 \
          align-check optimal ${rootPartition}
        '' else let swapEnd = 2 + (fromMiB swapSize); in ''
        parted --script $diskImage -- \
          mkpart ${escapeShellArg swapLabel} linux-swap ${toMiB 2} ${toMiB swapEnd} \
          align-check optimal ${swapPartition} \
          mkpart ${escapeShellArg label} ext4 ${toMiB swapEnd} -1 \
          align-check optimal ${rootPartition}
        ''}
    '';
    efi = ''
      parted --script $diskImage -- \
        mklabel gpt

      # We need to use gdisk to set the volume ID.
      echo "x g "${escapeShellArg bootUUID}" m w y" | tr ' ' '\n' | gdisk $diskImage

      # bootSize includes the padding at the start of the boot partition.
      parted --script $diskImage -- \
        mkpart ${escapeShellArg bootLabel} fat32 ${toMiB 8} ${toMiB bootSize} \
        set 1 boot on

      ${if swapSize == null then ''
        parted --script $diskImage -- \
          mkpart ${escapeShellArg label} ext4 ${toMiB bootSize} -1
      '' else let swapEnd = (fromMiB bootSize) + (fromMiB swapSize); in ''
        parted --script $diskImage -- \
          mkpart ${escapeShellArg swapLabel} linux-swap ${toMiB bootSize} ${toMiB swapEnd} \
          mkpart ${escapeShellArg label} ext4 ${toMiB swapEnd} -1
      ''}
    '';
    hybrid = ''
      parted --script $diskImage -- \
        mklabel gpt

      # We need to use gdisk to set the volume ID.
      echo "x g "${escapeShellArg bootUUID}" m w y" | tr ' ' '\n' | gdisk $diskImage

      parted --script $diskImage -- \
        mkpart ${escapeShellArg bootLabel} fat32 ${toMiB 8} ${toMiB bootSize} \
        set 1 boot on \
        mkpart no-fs 0 ${toMiB 1} \
        set 2 bios_grub on

      ${if swapSize == null then ''
        parted --script $diskImage -- \
          mkpart ${escapeShellArg label} ext4 ${toMiB bootSize} -1
        '' else let swapEnd = (fromMiB bootSize) + (fromMiB swapSize); in ''
        parted --script $diskImage -- \
          mkpart ${escapeShellArg swapLabel} linux-swap ${toMiB bootSize} ${toMiB swapEnd} \
          mkpart ${escapeShellArg label} ext4 ${toMiB swapEnd} -1
        ''}
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
      util-linux
      parted
      gptfdisk
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
  modes   = map (x: x.mode  or "''") contents;
  users   = map (x: x.user  or "''") contents;
  groups  = map (x: x.group or "''") contents;

  closureInfo = pkgs.closureInfo { rootPaths = [ config.system.build.toplevel channelSources ]; };

  blockSize = toString (4 * 1024); # ext4fs block size (not block device sector size)

  prepareImage = ''
    export PATH=${binPath}

    # Yes, mkfs.ext4 takes different units in different contexts. Fun.
    sectorsToKilobytes() {
      echo $(( ( "$1" * 512 ) / 1024 ))
    }

    sectorsToBytes() {
      echo $(( "$1" * 512  ))
    }

    # Given lines of numbers, adds them together
    sum_lines() {
      local acc=0
      while read -r number; do
        acc=$((acc+number))
      done
      echo "$acc"
    }

    mebibyte=$(( 1024 * 1024 ))

    # Approximative percentage of reserved space in an ext4 fs over 512MiB.
    # 0.05208587646484375
    #  × 1000, integer part: 52
    compute_fudge() {
      echo $(( $1 * 52 / 1000 ))
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
    modes_=(${concatStringsSep " " modes})
    set +f

    for ((i = 0; i < ''${#targets_[@]}; i++)); do
      source="''${sources_[$i]}"
      target="''${targets_[$i]}"
      mode="''${modes_[$i]}"

      if [ -n "$mode" ]; then
        rsync_chmod_flags="--chmod=$mode"
      else
        rsync_chmod_flags=""
      fi
      # Unfortunately cptofs only supports modes, not ownership, so we can't use
      # rsync's --chown option. Instead, we change the ownerships in the
      # VM script with chown.
      rsync_flags="-a --no-o --no-g $rsync_chmod_flags"
      if [[ "$source" =~ '*' ]]; then
        # If the source name contains '*', perform globbing.
        mkdir -p $root/$target
        for fn in $source; do
          rsync $rsync_flags "$fn" $root/$target/
        done
      else
        mkdir -p $root/$(dirname $target)
        if ! [ -e $root/$target ]; then
          rsync $rsync_flags $source $root/$target
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
      reservedSpace=$(( ${toString reservedSpaceBytes} ))
      additionalSpace=$(( ${toString (fromMiB additionalSpace)} * 1024 * 1024 + reservedSpace ))

      # Compute required space in filesystem blocks
      diskUsage=$(find . ! -type d -exec 'du' '--apparent-size' '--block-size' "${blockSize}" '{}' ';' | cut -f1 | sum_lines)
      # Each inode takes space!
      numInodes=$(find . | wc -l)
      # Convert to bytes, inodes take two blocks each!
      diskUsage=$(( (diskUsage + 2 * numInodes) * ${blockSize} ))
      # Then increase the required space to account for the reserved blocks.
      fudge=$(compute_fudge $diskUsage)
      requiredFilesystemSpace=$(( diskUsage + fudge ))

      diskSize=$(( requiredFilesystemSpace  + additionalSpace ))

      # Round up to the nearest mebibyte.
      # This ensures whole 512 bytes sector sizes in the disk image
      # and helps towards aligning partitions optimally.
      if (( diskSize % mebibyte )); then
        diskSize=$(( ( diskSize / mebibyte + 1) * mebibyte ))
      fi

      truncate -s "$diskSize" $diskImage

      printf "Automatic disk size...\n"
      printf "  Closure space use: %d bytes\n" $diskUsage
      printf "  fudge: %d bytes\n" $fudge
      printf "  Filesystem size needed: %d bytes\n" $requiredFilesystemSpace
      printf "  Additional space: %d bytes\n" $additionalSpace
      printf "  Disk image size: %d bytes\n" $diskSize
    '' else ''
      truncate -s ${toMiB diskSize} $diskImage
    ''}

    ${partitionDiskScript}
    parted --script $diskImage -- \
      unit MiB \
      print

    ${if partitionTableType != "none" then ''
      # Get start & length of the root partition in sectors to $START and $SECTORS.
      eval $(partx $diskImage -o START,SECTORS --nr ${rootPartition} --pairs)

      ${escapeShellArg "mkfs.${fsType}"} -b ${blockSize} -F -U ${escapeShellArg uuid} -L ${escapeShellArg label} $diskImage -E offset=$(sectorsToBytes $START) $(sectorsToKilobytes $SECTORS)K
    '' else ''
      ${escapeShellArg "mkfs.${fsType}"} -b ${blockSize} -F -U ${escapeShellArg uuid} -L ${escapeShellArg label} $diskImage
    ''}

    echo "copying staging root to image..."
    cptofs -p ${optionalString (partitionTableType != "none") "-P ${rootPartition}"} -t ${fsType} -i $diskImage $root/* / ||
      (echo >&2 "ERROR: cptofs failed. diskSize might be too small for closure."; exit 1)
  '';
in pkgs.vmTools.runInLinuxVM (
  pkgs.runCommand name
    { preVM = prepareImage;
      buildInputs = with pkgs; [ util-linux e2fsprogs dosfstools libfaketime ];
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

      # make systemd-boot find ESP without udev
      mkdir -p /dev/block
      ln -s /dev/vda1 /dev/block/254:1

      mountPoint=/mnt
      mkdir $mountPoint
      mount $rootDisk $mountPoint

      # Create the ESP and mount it. Unlike e2fsprogs, mkfs.vfat doesn't support an
      # '-E offset=X' option, so we can't do this outside the VM.
      ${optionalString (partitionTableType == "efi" || partitionTableType == "hybrid") ''
        mkdir -p /mnt/boot
        faketime "1970-01-01 00:00:00" mkfs.vfat -i ${escapeShellArg bootPartitionId} -n ${escapeShellArg (toUpper bootLabel)} /dev/vda1
        mount /dev/vda1 /mnt/boot
      ''}

      # Create the swapspace. Don't turn it on.
      ${optionalString (swapSize != null) ''
        mkswap -U ${escapeShellArg swapUUID} -L ${escapeShellArg swapLabel} /dev/vda${swapPartition}
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

      # Set the ownerships of the contents. The modes are set in preVM.
      # No globbing on targets, so no need to set -f
      targets_=(${concatStringsSep " " targets})
      users_=(${concatStringsSep " " users})
      groups_=(${concatStringsSep " " groups})
      for ((i = 0; i < ''${#targets_[@]}; i++)); do
        target="''${targets_[$i]}"
        user="''${users_[$i]}"
        group="''${groups_[$i]}"
        if [ -n "$user$group" ]; then
          # We have to nixos-enter since we need to use the user and group of the VM
          nixos-enter --root $mountPoint -- chown -R "$user:$group" "$target"
        fi
      done

      umount -R /mnt

      # Make sure resize2fs works. Note that resize2fs has stricter criteria for resizing than a normal
      # mount, so the `-c 0` and `-i 0` don't affect it. Setting it to `now` doesn't produce deterministic
      # output, of course, but we can fix that when/if we start making images deterministic.
      ${optionalString (fsType == "ext4") ''
        tune2fs -T now -c 0 -i 0 $rootDisk
      ''}
    ''
)
