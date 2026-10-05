/*
  Technical details

  `make-disk-image` has a bit of magic to minimize the amount of work to do in a virtual machine. It also might arguably have too much, or at least too specific magic, so please consider to work towards the effort of unifying our image builders, as outlined in https://github.com/NixOS/nixpkgs/issues/324817 before adding more.

  It relies on the [LKL (Linux Kernel Library) project](https://github.com/lkl/linux) which provides Linux kernel as userspace library.

  The Nix-store only image only need to run LKL tools to produce an image and will never spawn a virtual machine, whereas full images will always require a virtual machine, but also use LKL.

  ### Image preparation phase

  Image preparation phase will produce the initial image layout in a folder:

  - devise a root folder based on `$PWD`
  - prepare the contents by copying and restoring ACLs in this root folder
  - load in the Nix store database all additional paths computed by `pkgs.closureInfo` in a temporary Nix store
  - run `nixos-install` in a temporary folder
  - transfer from the temporary store the additional paths registered to the installed NixOS
  - compute the size of the disk image based on the apparent size of the root folder
  - partition the disk image using the corresponding script according to the partition table type
  - format the partitions if needed
  - use `cptofs` (LKL tool) to copy the root folder inside the disk image, or, with `populateRootWith = "mke2fs"`, create the root filesystem from the root folder in one step with `mke2fs -d`

  At this step, the disk image already contains the Nix store, it now only needs to be converted to the desired format to be used.

  ### Image conversion phase

  Using `qemu-img`, the disk image is converted from a raw format to the desired format: qcow2(-compressed), vdi, vpc.

  ### Image Partitioning

  #### `none`

  No partition table layout is written. The image is a bare filesystem image.

  #### `legacy`

  The image is partitioned using MBR. There is one primary ext4 partition starting at 1 MiB that fills the rest of the disk image.

  This partition layout is unsuitable for UEFI.

  #### `legacy+boot`

  The image is partitioned using MBR and:
  - creates a FAT32 BOOT partition from 1MiB to specified `bootSize` parameter (256MiB by default), set it bootable ;
  - creates a primary ext4 partition starting after the boot partition and extending to the full disk image

  This partition layout is unsuitable for UEFI.

  #### `legacy+gpt`

  This partition table type uses GPT and:

  - create a "no filesystem" partition from 1MiB to 2MiB ;
  - set `bios_grub` flag on this "no filesystem" partition, which marks it as a [GRUB BIOS partition](https://www.gnu.org/software/parted/manual/html_node/set.html) ;
  - create a primary ext4 partition starting at 2MiB and extending to the full disk image ;
  - perform optimal alignments checks on each partition

  This partition layout is unsuitable for UEFI boot, because it has no ESP (EFI System Partition) partition. It can work with CSM (Compatibility Support Module) which emulates legacy (BIOS) boot for UEFI.

  #### `efi`

  This partition table type uses GPT and:

  - creates an FAT32 ESP partition from 8MiB to specified `bootSize` parameter (256MiB by default), set it bootable ;
  - creates an primary ext4 partition starting after the boot partition and extending to the full disk image

  #### `efixbootldr`

  This partition table type uses GPT and:

  - creates an FAT32 ESP partition from 8MiB to 100MiB, set it bootable ;
  - creates an FAT32 BOOT partition from 100MiB to specified `bootSize` parameter (256MiB by default), set `bls_boot` flag ;
  - creates an primary ext4 partition starting after the boot partition and extending to the full disk image

  #### `hybrid`

  This partition table type uses GPT and:

  - creates a "no filesystem" partition from 0 to 1MiB, set `bios_grub` flag on it ;
  - creates an FAT32 ESP partition from 8MiB to specified `bootSize` parameter (256MiB by default), set it bootable ;
  - creates a primary ext4 partition starting after the boot one and extending to the full disk image

  This partition could be booted by a BIOS able to understand GPT layouts and recognizing the MBR at the start.

  ### How to run determinism analysis on results?

  Build your derivation with `--check` to rebuild it and verify it is the same.

  If it fails, you will be left with two folders with one having `.check`.

  You can use `diffoscope` to see the differences between the folders.

  However, `diffoscope` is currently not able to diff two QCOW2 filesystems, thus, it is advised to use raw format.

  Even if you use raw disks, `diffoscope` cannot diff the partition table and partitions recursively.

  To solve this, you can run `fdisk -l $image` and generate `dd if=$image of=$image-p$i.raw skip=$start count=$sectors` for each `(start, sectors)` listed in the `fdisk` output. Now, you will have each partition as a separate file and you can compare them in pairs.
*/
{
  pkgs,
  lib,

  # The NixOS configuration to be installed onto the disk image.
  config,

  # The size of the disk, in MiB (1024*1024 bytes).
  # if "auto" size is calculated based on the contents copied to it and
  #   additionalSpace is taken into account.
  diskSize ? "auto",

  # additional disk space to be added to the image if diskSize "auto"
  # is used
  additionalSpace ? "512M",

  # size of the boot partition, is only used if partitionTableType is
  # either "efi", "hybrid", or "legacy+boot"
  # This will be undersized slightly, as this is actually the offset of
  # the end of the partition. Generally it will be 1MiB smaller.
  bootSize ? "256M",

  # The files and directories to be placed in the target file system.
  # This is a list of attribute sets {source, target, mode, user, group} where
  # `source' is the file system object (regular file or directory) to be
  # grafted in the file system at path `target', `mode' is a string containing
  # the permissions that will be set (ex. "755"), `user' and `group' are the
  # user and group name that will be set as owner of the files.
  # `mode', `user', and `group' are optional.
  # When setting one of `user' or `group', the other needs to be set too.
  contents ? [ ],

  # Type of partition table to use; described in the `Image Partitioning` section above.
  partitionTableType ? "legacy",

  # Whether to invoke `switch-to-configuration boot` during image creation
  installBootLoader ? true,

  # Whether to output have EFIVARS available in $out/efi-vars.fd and use it during disk creation
  touchEFIVars ? false,

  # OVMF firmware derivation
  OVMF ? pkgs.OVMF.fd,

  # EFI firmware
  efiFirmware ? OVMF.firmware,

  # EFI variables
  efiVariables ? OVMF.variables,

  # The root file system type.
  fsType ? "ext4",

  # Filesystem label
  label ? if onlyNixStore then "nix-store" else "nixos",

  # The initial NixOS configuration file to be copied to
  # /etc/nixos/configuration.nix.
  configFile ? null,

  # Shell code executed after the VM has finished.
  postVM ? "",

  # Guest memory size in MiB (1024*1024 bytes)
  memSize ? 1024,

  # Copy the contents of the Nix store to the root of the image and
  # skip further setup. Incompatible with `contents`,
  # `installBootLoader` and `configFile`.
  onlyNixStore ? false,

  name ? "nixos-disk-image",

  # Disk image format, one of qcow2, qcow2-compressed, vdi, vpc, raw.
  format ? "raw",

  # Disk image filename, without any extensions (e.g. `image_1`).
  baseName ? "nixos",

  # Whether to fix:
  #   - GPT Disk Unique Identifier (diskGUID)
  #   - GPT Partition Unique Identifier: depends on the layout, root partition UUID can be controlled through `rootGPUID` option
  #   - GPT Partition Type Identifier: fixed according to the layout, e.g. ESP partition, etc. through `parted` invocation.
  #   - Filesystem Unique Identifier when fsType = ext4 for *root partition*.
  # BIOS/MBR support is "best effort" at the moment.
  # Boot partitions may not be deterministic.
  # Also, to fix last time checked of the ext4 partition if fsType = ext4.
  deterministic ? true,

  # Whether to make the image bit-for-bit reproducible: two builds from the
  # same inputs produce identical files, so `nix build --rebuild` passes.
  # Requires `deterministic` and an ext2, ext3 or ext4 root filesystem, and
  # populates it with mke2fs. It costs some build time: the build VM gets a
  # single CPU, and the filesystems are normalised after the VM has run.
  # See "How to run determinism analysis on results?" above.
  reproducible ? false,

  # GPT Partition Unique Identifier for root partition.
  rootGPUID ? "F222513B-DED1-49FA-B591-20CE86A2FE7F",
  # When fsType = ext4, this is the root Filesystem Unique Identifier.
  # TODO: support other filesystems someday.
  rootFSUID ? (if fsType == "ext4" then rootGPUID else null),

  # How the staging root folder gets into the root filesystem:
  # - "cptofs": format the filesystem, then copy the folder in with LKL's `cptofs`.
  # - "mke2fs": create and populate the filesystem in one pass with `mke2fs -d`.
  #   Only for ext2, ext3 and ext4. It needs no kernel and writes the
  #   filesystem from a single thread, in a fixed order.
  populateRootWith ? if reproducible then "mke2fs" else "cptofs",

  # In deterministic mode with populateRootWith = "mke2fs", the seed for the
  # ext4 directory index hashes (a UUID). mke2fs picks a random one otherwise.
  rootFSHashSeed ? rootFSUID,

  # Whether a nix channel based on the current source tree should be
  # made available inside the image. Useful for interactive use of nix
  # utils, but changes the hash of the image when the sources are
  # updated.
  copyChannel ? true,

  # Additional store paths to copy to the image's store.
  additionalPaths ? [ ],
}:

assert (
  lib.assertOneOf "partitionTableType" partitionTableType [
    "legacy"
    "legacy+boot"
    "legacy+gpt"
    "efi"
    "efixbootldr"
    "hybrid"
    "none"
  ]
);
assert (
  lib.assertMsg (fsType == "ext4" && deterministic -> rootFSUID != null)
    "In deterministic mode with a ext4 partition, rootFSUID must be non-null, by default, it is equal to rootGPUID."
);
assert (
  lib.assertOneOf "populateRootWith" populateRootWith [
    "cptofs"
    "mke2fs"
  ]
);
assert (
  lib.assertMsg (
    populateRootWith == "mke2fs"
    -> lib.elem fsType [
      "ext2"
      "ext3"
      "ext4"
    ]
  ) "populateRootWith = \"mke2fs\" needs an ext2, ext3 or ext4 root filesystem."
);
assert (
  lib.assertMsg
    (
      reproducible
      ->
        deterministic
        && populateRootWith == "mke2fs"
        && lib.elem fsType [
          "ext2"
          "ext3"
          "ext4"
        ]
    )
    "reproducible = true needs deterministic = true and an ext2, ext3 or ext4 root filesystem populated with mke2fs."
);
# We use -E offset=X below, which is only supported by e2fsprogs
assert (
  lib.assertMsg (partitionTableType != "none" -> fsType == "ext4")
    "to produce a partition table, we need to use -E offset flag which is support only for fsType = ext4"
);
assert (
  lib.assertMsg
    (
      touchEFIVars
      ->
        partitionTableType == "hybrid"
        || partitionTableType == "efi"
        || partitionTableType == "efixbootldr"
        || partitionTableType == "legacy+gpt"
    )
    "EFI variables can be used only with a partition table of type: hybrid, efi, efixbootldr, or legacy+gpt."
);
# If only Nix store image, then: contents must be empty, configFile must be unset, and we should no install bootloader.
assert (
  lib.assertMsg (onlyNixStore -> contents == [ ] && configFile == null && !installBootLoader)
    "In a only Nix store image, the contents must be empty, no configuration must be provided and no bootloader should be installed."
);
# Either both or none of {user,group} need to be set
assert (
  lib.assertMsg (lib.all (
    attrs: ((attrs.user or null) == null) == ((attrs.group or null) == null)
  ) contents) "Contents of the disk image should set none of {user, group} or both at the same time."
);

let
  format' = format;
in
let

  format = if format' == "qcow2-compressed" then "qcow2" else format';

  compress = lib.optionalString (format' == "qcow2-compressed") "-c";

  filename =
    "${baseName}."
    + {
      qcow2 = "qcow2";
      vdi = "vdi";
      vpc = "vhd";
      raw = "img";
    }
    .${format} or format;

  rootPartition =
    {
      # switch-case
      legacy = "1";
      "legacy+boot" = "2";
      "legacy+gpt" = "2";
      efi = "2";
      efixbootldr = "3";
      hybrid = "3";
    }
    .${partitionTableType};

  partitionDiskScript =
    {
      # switch-case
      legacy = ''
        parted --script $diskImage -- \
          mklabel msdos \
          mkpart primary ext4 1MiB 100% \
          print
      '';
      "legacy+boot" = ''
        parted --script $diskImage -- \
          mklabel msdos \
          mkpart primary fat32 1MiB $bootSizeMiB \
          set 1 boot on \
          mkpart primary ext4 $bootSizeMiB 100% \
          print
      '';
      "legacy+gpt" = ''
        parted --script $diskImage -- \
          mklabel gpt \
          mkpart no-fs 1MiB 2MiB \
          set 1 bios_grub on \
          mkpart primary ext4 2MiB 100% \
          align-check optimal 2 \
          print
        ${lib.optionalString deterministic ''
          sgdisk \
          --disk-guid=97FD5997-D90B-4AA3-8D16-C1723AEA73C \
          --partition-guid=1:1C06F03B-704E-4657-B9CD-681A087A2FDC \
          --partition-guid=2:970C694F-AFD0-4B99-B750-CDB7A329AB6F \
          --partition-guid=3:${rootGPUID} \
          $diskImage
        ''}
      '';
      efi = ''
        parted --script $diskImage -- \
          mklabel gpt \
          mkpart ESP fat32 8MiB $bootSizeMiB \
          set 1 boot on \
          align-check optimal 1 \
          mkpart primary ext4 $bootSizeMiB 100% \
          align-check optimal 2 \
          print
        ${lib.optionalString deterministic ''
          sgdisk \
          --disk-guid=97FD5997-D90B-4AA3-8D16-C1723AEA73C \
          --partition-guid=1:1C06F03B-704E-4657-B9CD-681A087A2FDC \
          --partition-guid=2:${rootGPUID} \
          $diskImage
        ''}
      '';
      efixbootldr = ''
        parted --script $diskImage -- \
          mklabel gpt \
          mkpart ESP fat32 8MiB 100MiB \
          set 1 boot on \
          align-check optimal 1 \
          mkpart BOOT fat32 100MiB $bootSizeMiB \
          set 2 bls_boot on \
          align-check optimal 2 \
          mkpart ROOT ext4 $bootSizeMiB 100% \
          align-check optimal 3 \
          print
        ${lib.optionalString deterministic ''
          sgdisk \
          --disk-guid=97FD5997-D90B-4AA3-8D16-C1723AEA73C \
          --partition-guid=1:1C06F03B-704E-4657-B9CD-681A087A2FDC  \
          --partition-guid=2:970C694F-AFD0-4B99-B750-CDB7A329AB6F  \
          --partition-guid=3:${rootGPUID} \
          $diskImage
        ''}
      '';
      hybrid = ''
        parted --script $diskImage -- \
          mklabel gpt \
          mkpart ESP fat32 8MiB $bootSizeMiB \
          set 1 boot on \
          align-check optimal 1 \
          mkpart no-fs 0 1024KiB \
          set 2 bios_grub on \
          mkpart primary ext4 $bootSizeMiB 100% \
          align-check optimal 3 \
          print
        ${lib.optionalString deterministic ''
          sgdisk \
          --disk-guid=97FD5997-D90B-4AA3-8D16-C1723AEA73C \
          --partition-guid=1:1C06F03B-704E-4657-B9CD-681A087A2FDC \
          --partition-guid=2:970C694F-AFD0-4B99-B750-CDB7A329AB6F \
          --partition-guid=3:${rootGPUID} \
          $diskImage
        ''}
      '';
      none = "";
    }
    .${partitionTableType};

  useEFIBoot = touchEFIVars;

  nixpkgs = lib.cleanSource pkgs.path;

  # FIXME: merge with channel.nix / make-channel.nix.
  channelSources = pkgs.runCommand "nixos-${config.system.nixos.version}" { } ''
    mkdir -p $out
    cp -prd ${nixpkgs.outPath} $out/nixos
    chmod -R u+w $out/nixos
    if [ ! -e $out/nixos/nixpkgs ]; then
      ln -s . $out/nixos/nixpkgs
    fi
    rm -rf $out/nixos/.git
    echo -n ${config.system.nixos.versionSuffix} > $out/nixos/.version-suffix
  '';

  binPath = lib.makeBinPath (
    with pkgs;
    [
      rsync
      util-linux
      parted
      e2fsprogs
      config.system.build.nixos-install
      nixos-enter
      nix
      systemdMinimal
    ]
    ++ lib.optional (populateRootWith == "cptofs") lkl
    ++ lib.optional deterministic gptfdisk
    ++ lib.optionals reproducible [
      mtools
      sqlite
    ]
    ++ stdenv.initialPath
  );

  # I'm preserving the line below because I'm going to search for it across nixpkgs to consolidate
  # image building logic. The comment right below this now appears in 4 different places in nixpkgs :)
  # !!! should use XML.
  sources = map (x: x.source) contents;
  targets = map (x: x.target) contents;
  modes = map (x: x.mode or "''") contents;
  users = map (x: x.user or "''") contents;
  groups = map (x: x.group or "''") contents;

  basePaths = [ config.system.build.toplevel ] ++ lib.optional copyChannel channelSources;

  additionalPaths' = lib.subtractLists basePaths additionalPaths;

  closureInfo = pkgs.closureInfo {
    rootPaths = basePaths ++ additionalPaths';
  };

  blockSize = toString (4 * 1024); # ext4fs block size (not block device sector size)

  # nixos-enter runs the activation script and the bootloader installer,
  # which are partly Perl and Python. Their hash tables otherwise iterate in a
  # random order, and so may create and write files in a random order.
  hashSeedEnv = lib.optionalString reproducible "PERL_HASH_SEED=0 PERL_PERTURB_KEYS=0 PYTHONHASHSEED=0 ";

  # The FAT boot partitions the build VM creates and mounts.
  bootPartitions =
    let
      esp = {
        device = "/dev/vda1";
        label = "ESP";
        mountPoint = "/mnt/boot";
      };
    in
    {
      efi = [ esp ];
      hybrid = [ esp ];
      "legacy+boot" = [ (esp // { label = "BOOT"; }) ];
      efixbootldr = [
        (esp // { mountPoint = "/mnt/efi"; })
        {
          device = "/dev/vda2";
          label = "BOOT";
          mountPoint = "/mnt/boot";
        }
      ];
    }
    .${partitionTableType} or [ ];

  # mkfs.vfat otherwise derives the volume ID and the root directory's times
  # from the clock.
  mkfsVfat = "mkfs.vfat" + lib.optionalString reproducible " --invariant";

  # Recreates each FAT boot partition from its files, in a fixed order and
  # with fixed times. The kernel's vfat driver records when the bootloader
  # installer wrote each file, and places the files in the order it wrote
  # them. mtools takes its times from SOURCE_DATE_EPOCH.
  rebuildBootPartitions = lib.concatMapStrings (p: ''
    echo "rebuilding the ${p.label} partition..."
    staging=/tmp/staging${p.mountPoint}
    mkdir -p $staging
    cp -r ${p.mountPoint}/. $staging/
    umount ${p.mountPoint}
    find $staging -exec touch -h -d @$SOURCE_DATE_EPOCH {} +
    # mkfs.vfat leaves the data area as it was.
    blkdiscard --zeroout ${p.device}
    ${mkfsVfat} -n ${p.label} ${p.device}
    (cd $staging && find . -mindepth 1 -type d -printf '%P\n' | LC_ALL=C sort) |
      while IFS= read -r dir; do
        MTOOLS_SKIP_CHECK=1 mmd -i ${p.device} "::/$dir"
      done
    (cd $staging && find . -type f -printf '%P\n' | LC_ALL=C sort) |
      while IFS= read -r file; do
        MTOOLS_SKIP_CHECK=1 mcopy -m -i ${p.device} "$staging/$file" "::/$file"
      done
  '') bootPartitions;

  # Lists the inodes of the root filesystem that the build VM created or
  # changed. Everything mke2fs wrote is at or before SOURCE_DATE_EPOCH, and the
  # root filesystem is mounted noatime, so these are the inodes with a later
  # access, change or modification time. rebuildBootPartitions has unmounted
  # the boot partitions, so that their mount points are seen and not crossed.
  recordTouchedInodes = ''
    find /mnt -xdev \( -newerat @$SOURCE_DATE_EPOCH -o -newermt @$SOURCE_DATE_EPOCH -o -newerct @$SOURCE_DATE_EPOCH \) \
      -printf '%i\n' | sort -nu > /tmp/touched-inodes
    echo "the build VM touched $(wc -l < /tmp/touched-inodes) inodes of the root filesystem"
  '';

  # Rewrites what the build VM's kernel left in the unmounted root filesystem
  # that depends on when and how the build ran. e2fsprogs takes its own
  # timestamps from SOURCE_DATE_EPOCH.
  normaliseRootFilesystem = ''
    echo "normalising the root filesystem..."

    # The times and generation numbers of the inodes the VM touched.
    while read -r ino; do
      echo "sif <$ino> generation 0"
      for field in atime mtime ctime crtime; do
        echo "sif <$ino> $field @$SOURCE_DATE_EPOCH"
        echo "sif <$ino> ''${field}_extra 0"
      done
    done < /tmp/touched-inodes > /tmp/normalise.debugfs
    # The superblock's mount time and counters.
    for field in "mtime @$SOURCE_DATE_EPOCH" "mnt_count 0" "kbytes_written 0" "last_orphan 0"; do
      echo "ssv $field"
    done >> /tmp/normalise.debugfs
    debugfs -w -f /tmp/normalise.debugfs $rootDisk > /dev/null 2> /tmp/normalise.err
    if grep -v '^debugfs [0-9]' /tmp/normalise.err; then
      echo "debugfs failed to normalise the root filesystem" >&2
      exit 1
    fi

    # Inodes the VM created and deleted are free, but keep their contents.
    # Zero every free inode below each group's high-water mark: inodes above it
    # were never used, and all-zero inodes are what mke2fs leaves. This needs
    # the group descriptor checksums (metadata_csum or uninit_bg) that record
    # the mark, which ext4 has by default.
    dumpe2fs $rootDisk 2> /dev/null | awk '
      /^Block size:/ { bs = $3 }
      /^Inodes per group:/ { ipg = $4 }
      /^Inode size:/ { isz = $3 }
      /^Group [0-9]+:/ { g = $2 + 0; limit = -1 }
      /^  Inode table at / { split($4, t, "-"); table = t[1] }
      / unused inodes$/ { limit = g * ipg + ipg - $(NF - 2); marks++ }
      /^  Free inodes: / {
        sub(/^  Free inodes: */, "")
        n = split($0, ranges, ", ")
        for (i = 1; i <= n; i++) {
          if (ranges[i] == "") continue
          split(ranges[i], r, "-")
          first = r[1] + 0
          last = (2 in r) ? r[2] + 0 : first
          if (last > limit) last = limit
          if (first > last) continue
          printf "%d %d %d\n", isz, table * bs / isz + first - 1 - g * ipg, last - first + 1
        }
      }
      END { if (!marks) { print "no inode table high-water marks" > "/dev/stderr"; exit 1 } }
    ' > /tmp/free-inodes
    while read -r size seek count; do
      dd if=/dev/zero of=$rootDisk bs=$size seek=$seek count=$count conv=notrunc status=none
    done < /tmp/free-inodes
    echo "zeroed $(awk '{ n += $3 } END { print n + 0 }' /tmp/free-inodes) free inodes"

    # Rebuild the directories, dropping what deleted entries left in them.
    # e2fsck exits with 1 when it has changed the filesystem, as -D always does.
    e2fsck -fyD $rootDisk > /tmp/e2fsck.log || [ $? -le 1 ] || {
      cat /tmp/e2fsck.log
      exit 1
    }

    # The journal still holds the VM's transactions, with their commit times.
    tune2fs -O ^has_journal $rootDisk > /dev/null
    tune2fs -O has_journal $rootDisk > /dev/null

    # Free blocks keep whatever the VM, or the old journal, last wrote into
    # them. List them, as byte ranges of the root partition, for
    # zeroRootFreeBlocks.
    dumpe2fs $rootDisk 2> /dev/null | awk '
      /^Block size:/ { bs = $3 }
      /^  Free blocks: / {
        sub(/^  Free blocks: */, "")
        n = split($0, ranges, ", ")
        for (i = 1; i <= n; i++) {
          if (ranges[i] == "") continue
          split(ranges[i], r, "-")
          first = r[1] + 0
          last = (2 in r) ? r[2] + 0 : first
          printf "%d %d\n", first * bs, (last - first + 1) * bs
        }
      }
    ' > /tmp/xchg/root-free-blocks
  '';

  # Zeroes the root filesystem's free blocks in the image file, once the VM
  # has stopped, by punching holes into it: the image stays sparse.
  zeroRootFreeBlocks = ''
    rootOffset=${
      if partitionTableType != "none" then
        "$(( $(partx $diskImage -g -o START --nr ${rootPartition}) * 512 ))"
      else
        "0"
    }
    while read -r offset length; do
      fallocate --punch-hole --keep-size --offset $((rootOffset + offset)) --length $length $diskImage
    done < xchg/root-free-blocks
  '';

  # The staging folder that becomes the root of the filesystem.
  stagingRoot = "$root" + lib.optionalString onlyNixStore builtins.storeDir;

  mkfsExtendedOptions = lib.concatStringsSep "," (
    lib.optional (partitionTableType != "none") "offset=$(sectorsToBytes $START)"
    ++ lib.optional (
      populateRootWith == "mke2fs" && deterministic && rootFSHashSeed != null
    ) "hash_seed=${rootFSHashSeed}"
  );

  mkfsCommand = lib.concatStringsSep " " (
    [
      "mkfs.${fsType}"
      "-b ${blockSize}"
      "-F"
      "-L ${label}"
    ]
    ++ lib.optionals (populateRootWith == "mke2fs") (
      [ "-d ${stagingRoot}" ] ++ lib.optional (deterministic && rootFSUID != null) "-U ${rootFSUID}"
    )
    ++ lib.optional (mkfsExtendedOptions != "") "-E ${mkfsExtendedOptions}"
    ++ [ "$diskImage" ]
    ++ lib.optional (partitionTableType != "none") "$(sectorsToKilobytes $SECTORS)K"
  );

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

    round_to_nearest() {
      echo $(( ( $1 / $2 + 1) * $2 ))
    }

    mkdir $out

    root="$PWD/root"
    mkdir -p $root

    # Copy arbitrary other files into the image
    # Semi-shamelessly copied from make-etc.sh.
    set -f
    sources_=(${lib.concatStringsSep " " sources})
    targets_=(${lib.concatStringsSep " " targets})
    modes_=(${lib.concatStringsSep " " modes})
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
        if [ -e $root/$target ]; then
          echo "duplicate entry $target -> $source"
          exit 1
        elif [ -d $source ]; then
          # Append a slash to the end of source to get rsync to copy the
          # directory _to_ the target instead of _inside_ the target.
          # (See `man rsync`'s note on a trailing slash.)
          rsync $rsync_flags $source/ $root/$target
        else
          rsync $rsync_flags $source $root/$target
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
      --system ${config.system.build.toplevel} \
      ${if copyChannel then "--channel ${channelSources}" else "--no-channel-copy"} \
      --substituters ""

    ${lib.optionalString (additionalPaths' != [ ]) ''
      nix --extra-experimental-features nix-command copy --to $root --no-check-sigs ${lib.concatStringsSep " " additionalPaths'}
    ''}

    ${lib.optionalString reproducible ''
      # nixos-install and nix copy register each store path as its copy
      # completes, several at a time: the database numbers the paths in that
      # order and records when each was registered. Register the same paths
      # again from the closure's sorted registration, and date them all
      # SOURCE_DATE_EPOCH.
      db=$root/nix/var/nix/db
      mv $db $TMPDIR/copied-db
      nix-store --store $root --load-db < ${closureInfo}/registration
      sqlite3 $db/db.sqlite "UPDATE ValidPaths SET registrationTime = $SOURCE_DATE_EPOCH"
      rm -f $db/db.sqlite-wal $db/db.sqlite-shm
      # Both must describe the same store paths and references.
      describe() {
        sqlite3 "$1" "SELECT path, hash, narSize, deriver FROM ValidPaths ORDER BY path;
          SELECT a.path, b.path FROM Refs JOIN ValidPaths a ON a.id = referrer
            JOIN ValidPaths b ON b.id = reference ORDER BY 1, 2"
      }
      if ! cmp -s <(describe $TMPDIR/copied-db/db.sqlite) <(describe $db/db.sqlite); then
        echo "ERROR: the re-registered Nix database differs from the copied one" >&2
        exit 1
      fi
      rm -r $TMPDIR/copied-db
    ''}

    diskImage=nixos.raw

    bootSize=$(round_to_nearest $(numfmt --from=iec '${bootSize}') $mebibyte)
    bootSizeMiB=$(( bootSize / 1024 / 1024 ))MiB

    ${
      if diskSize == "auto" then
        ''
          ${
            if
              partitionTableType == "efi" || partitionTableType == "efixbootldr" || partitionTableType == "hybrid"
            then
              ''
                # Add the GPT at the end
                gptSpace=$(( 512 * 34 * 1 ))
                # Normally we'd need to account for alignment and things, if bootSize
                # represented the actual size of the boot partition. But it instead
                # represents the offset at which it ends.
                # So we know bootSize is the reserved space in front of the partition.
                reservedSpace=$(( gptSpace + bootSize ))
              ''
            else if partitionTableType == "legacy+gpt" then
              ''
                # Add the GPT at the end
                gptSpace=$(( 512 * 34 * 1 ))
                # And include the bios_grub partition; the ext4 partition starts at 2MiB exactly.
                reservedSpace=$(( gptSpace + 2 * mebibyte ))
              ''
            else if partitionTableType == "legacy" then
              ''
                # Add the 1MiB aligned reserved space (includes MBR)
                reservedSpace=$(( mebibyte ))
              ''
            else if partitionTableType == "legacy+boot" then
              ''
                # The explanation from the above "efi" case applies here too,
                # but gptSpace is not needed without a GPT.
                reservedSpace=$(( bootSize ))
              ''
            else
              ''
                reservedSpace=0
              ''
          }
          additionalSpace=$(( $(numfmt --from=iec '${additionalSpace}') + reservedSpace ))

          # Compute required space in filesystem blocks
          diskUsage=$(find . ! -type d -print0 | du --files0-from=- --apparent-size --count-links --block-size "${blockSize}" | cut -f1 | sum_lines)
          # Each inode takes space!
          numInodes=$(find . | wc -l)
          # Convert to bytes, inodes take two blocks each!
          diskUsage=$(( (diskUsage + 2 * numInodes) * ${blockSize} ))
          # Then increase the required space to account for the reserved blocks.
          fudge=$(compute_fudge $diskUsage)
          requiredFilesystemSpace=$(( diskUsage + fudge ))

          # Round up to the nearest block size.
          # This ensures whole $blockSize bytes block sizes in the filesystem
          # and helps towards aligning partitions optimally.
          requiredFilesystemSpace=$(round_to_nearest $requiredFilesystemSpace ${blockSize})

          diskSize=$(( requiredFilesystemSpace + additionalSpace ))

          # Round up to the nearest mebibyte.
          # This ensures whole 512 bytes sector sizes in the disk image
          # and helps towards aligning partitions optimally.
          diskSize=$(round_to_nearest $diskSize $mebibyte)

          truncate -s "$diskSize" $diskImage

          printf "Automatic disk size...\n"
          printf "  Closure space use: %d bytes\n" $diskUsage
          printf "  fudge: %d bytes\n" $fudge
          printf "  Filesystem size needed: %d bytes\n" $requiredFilesystemSpace
          printf "  Additional space: %d bytes\n" $additionalSpace
          printf "  Disk image size: %d bytes\n" $diskSize
        ''
      else
        ''
          truncate -s ${toString diskSize}M $diskImage
        ''
    }

    ${partitionDiskScript}

    ${lib.optionalString (partitionTableType != "none") ''
      # Get start & length of the root partition in sectors to $START and $SECTORS.
      eval $(partx $diskImage -o START,SECTORS --nr ${rootPartition} --pairs)
    ''}

    ${
      if populateRootWith == "mke2fs" then
        ''
          echo "creating the root filesystem from the staging root..."
          ${lib.optionalString onlyNixStore ''
            # cptofs copies the store's entries into a fresh root directory,
            # while mke2fs -d gives the root directory the folder's own mode.
            chmod 0755 ${stagingRoot}
          ''}
          # mke2fs -d records each file's owner, and the staging root belongs to
          # the build user. A user namespace that maps that user to root makes
          # the files belong to root, as cptofs would have them. e2fsprogs
          # takes its timestamps from SOURCE_DATE_EPOCH.
          unshare --map-root-user ${mkfsCommand} ||
            (echo >&2 "ERROR: mke2fs failed. diskSize might be too small for closure."; exit 1)
        ''
      else
        ''
          ${mkfsCommand}

          echo "copying staging root to image..."
          cptofs -p ${lib.optionalString (partitionTableType != "none") "-P ${rootPartition}"} \
                 -t ${fsType} \
                 -i $diskImage \
                 ${stagingRoot}/* / ||
            (echo >&2 "ERROR: cptofs failed. diskSize might be too small for closure."; exit 1)
        ''
    }
  '';

  # The VHD footer's unique ID, as printf escapes.
  vhdUniqueId =
    let
      hex = lib.toLower (lib.replaceStrings [ "-" ] [ "" ] rootGPUID);
    in
    lib.concatMapStrings (i: "\\x" + builtins.substring (2 * i) 2 hex) (lib.range 0 15);

  # Defines normaliseVhdFooter, which postVM can also call on a VHD it
  # converts itself. qemu-img writes the current time and a random unique ID
  # into the footer of a VHD (format "vpc"); this sets the time from
  # SOURCE_DATE_EPOCH (VHD times count from 2000-01-01, so earlier dates become
  # 0) and the ID to rootGPUID, and recomputes the checksum. A dynamic VHD
  # also has a copy of the footer at its start.
  defineNormaliseVhdFooter = ''
    normaliseVhdFooterAt() {
      local file=$1 offset=$2 time sum
      if [ "$(dd if="$file" bs=1 skip="$offset" count=8 status=none | tr -d '\0')" != conectix ]; then
        echo "normaliseVhdFooter: no VHD footer at offset $offset of $file" >&2
        return 1
      fi
      vhdWriteBytes() {
        printf "$3" | dd of="$1" bs=1 seek=$(($2)) conv=notrunc status=none
      }
      vhdBe32() {
        printf '\\x%02x\\x%02x\\x%02x\\x%02x' $(($1 >> 24 & 255)) $(($1 >> 16 & 255)) $(($1 >> 8 & 255)) $(($1 & 255))
      }
      time=$((SOURCE_DATE_EPOCH > 946684800 ? SOURCE_DATE_EPOCH - 946684800 : 0))
      vhdWriteBytes "$file" "offset + 24" "$(vhdBe32 $time)"
      vhdWriteBytes "$file" "offset + 68" '${vhdUniqueId}'
      vhdWriteBytes "$file" "offset + 64" '\x00\x00\x00\x00'
      sum=$(od -An -v -tu1 -j "$offset" -N 512 "$file" | awk '{ for (i = 1; i <= NF; i++) s += $i } END { print s }')
      vhdWriteBytes "$file" "offset + 64" "$(vhdBe32 $((~sum & 0xFFFFFFFF)))"
    }
    normaliseVhdFooter() {
      local file=$1
      normaliseVhdFooterAt "$file" $(($(stat -c %s "$file") - 512)) || return 1
      if [ "$(head -c 8 "$file" | tr -d '\0')" = conectix ]; then
        normaliseVhdFooterAt "$file" 0
      fi
    }
  '';

  moveOrConvertImage = ''
    ${lib.optionalString reproducible defineNormaliseVhdFooter}
    ${
      if format == "raw" then
        ''
          mv $diskImage $out/${filename}
        ''
      else
        ''
          ${pkgs.qemu-utils}/bin/qemu-img convert -f raw -O ${format} ${compress} $diskImage $out/${filename}
          ${lib.optionalString (reproducible && format == "vpc") "normaliseVhdFooter $out/${filename}"}
        ''
    }
    diskImage=$out/${filename}
  '';

  createEFIVars = ''
    efiVars=$out/efi-vars.fd
    cp ${efiVariables} $efiVars
    chmod 0644 $efiVars
  '';

  createHydraBuildProducts = ''
    mkdir -p $out/nix-support
    echo "file ${format}-image $out/${filename}" >> $out/nix-support/hydra-build-products
  '';

  buildImage = pkgs.vmTools.runInLinuxVM (
    pkgs.runCommand name
      {
        preVM = prepareImage + lib.optionalString touchEFIVars createEFIVars;
        buildInputs = with pkgs; [
          util-linux
          e2fsprogs
          dosfstools
        ];
        postVM =
          lib.optionalString reproducible zeroRootFreeBlocks
          + moveOrConvertImage
          + createHydraBuildProducts
          + postVM;
        QEMU_OPTS = lib.concatStringsSep " " (
          lib.optional useEFIBoot "-drive if=pflash,format=raw,unit=0,readonly=on,file=${efiFirmware}"
          ++ lib.optionals touchEFIVars [
            "-drive if=pflash,format=raw,unit=1,file=$efiVars"
          ]
          ++ lib.optionals (OVMF.systemManagementModeRequired or false) [
            "-machine"
            "q35,smm=on"
            "-global"
            "driver=cfi.pflash01,property=secure,value=on"
          ]
        );
        inherit memSize;
        # runCommand gives the VM one vCPU per build core. ext4 serves block
        # and inode allocations from per-CPU pools, so with several vCPUs the
        # layout depends on which one each write in the VM happened to run on.
        # A reproducible image gets a single vCPU.
        enableParallelBuilding = !reproducible;
      }
      ''
        export PATH=${binPath}:$PATH

        rootDisk=${if partitionTableType != "none" then "/dev/vda${rootPartition}" else "/dev/vda"}

        # It is necessary to set root filesystem unique identifier in advance, otherwise
        # bootloader might get the wrong one and fail to boot.
        # At the end, we reset again because we want deterministic timestamps.
        ${lib.optionalString (fsType == "ext4" && deterministic) ''
          tune2fs -T now ${lib.optionalString deterministic "-U ${rootFSUID}"} -c 0 -i 0 $rootDisk
        ''}
        # make systemd-boot find ESP without udev
        mkdir /dev/block
        ln -s /dev/vda1 /dev/block/254:1

        mountPoint=/mnt
        mkdir $mountPoint
        mount ${lib.optionalString reproducible "-o noatime"} $rootDisk $mountPoint

        # Create the ESP and mount it. Unlike e2fsprogs, mkfs.vfat doesn't support an
        # '-E offset=X' option, so we can't do this outside the VM.
        ${lib.optionalString (partitionTableType == "efi" || partitionTableType == "hybrid") ''
          mkdir -p /mnt/boot
          ${mkfsVfat} -n ESP /dev/vda1
          mount /dev/vda1 /mnt/boot

          ${lib.optionalString touchEFIVars "mount -t efivarfs efivarfs /sys/firmware/efi/efivars"}
        ''}
        ${lib.optionalString (partitionTableType == "efixbootldr") ''
          mkdir -p /mnt/{boot,efi}
          ${mkfsVfat} -n ESP /dev/vda1
          ${mkfsVfat} -n BOOT /dev/vda2
          mount /dev/vda1 /mnt/efi
          mount /dev/vda2 /mnt/boot

          ${lib.optionalString touchEFIVars "mount -t efivarfs efivarfs /sys/firmware/efi/efivars"}
        ''}
        ${lib.optionalString (partitionTableType == "legacy+boot") ''
          mkdir -p /mnt/boot
          ${mkfsVfat} -n BOOT /dev/vda1
          mount /dev/vda1 /mnt/boot
        ''}

        # Install a configuration.nix
        mkdir -p /mnt/etc/nixos
        ${lib.optionalString (configFile != null) ''
          cp ${configFile} /mnt/etc/nixos/configuration.nix
        ''}

        ${lib.optionalString installBootLoader ''
          # In this throwaway resource, we only have /dev/vda, but the actual VM may refer to another disk for bootloader, e.g. /dev/vdb
          # Use this option to create a symlink from vda to any arbitrary device you want.
          ${lib.optionalString (config.boot.loader.grub.enable) (
            lib.concatMapStringsSep " " (
              device:
              lib.optionalString (device != "/dev/vda") ''
                mkdir -p "$(dirname ${device})"
                ln -s /dev/vda ${device}
              ''
            ) config.boot.loader.grub.devices
          )}
          ${
            let
              limine = config.boot.loader.limine;
            in
            lib.optionalString (limine.enable && limine.biosSupport && limine.biosDevice != "/dev/vda") ''
              mkdir -p "$(dirname ${limine.biosDevice})"
              ln -s /dev/vda ${limine.biosDevice}
            ''
          }

          # Set up core system link, bootloader (sd-boot, GRUB, uboot, etc.), etc.

          # NOTE: systemd-boot-builder.py calls nix-env --list-generations which
          # clobbers $HOME/.nix-defexpr/channels/nixos This would cause a  folder
          # /homeless-shelter to show up in the final image which  in turn breaks
          # nix builds in the target image if sandboxing is turned off (through
          # __noChroot for example).
          export HOME=$TMPDIR
          ${hashSeedEnv}NIXOS_INSTALL_BOOTLOADER=1 nixos-enter --root $mountPoint -- /nix/var/nix/profiles/system/bin/switch-to-configuration boot
        ''}

        # Set the ownerships of the contents. The modes are set in preVM.
        # No globbing on targets, so no need to set -f
        targets_=(${lib.concatStringsSep " " targets})
        users_=(${lib.concatStringsSep " " users})
        groups_=(${lib.concatStringsSep " " groups})
        for ((i = 0; i < ''${#targets_[@]}; i++)); do
          target="''${targets_[$i]}"
          user="''${users_[$i]}"
          group="''${groups_[$i]}"
          if [ -n "$user$group" ]; then
            # We have to nixos-enter since we need to use the user and group of the VM
            ${hashSeedEnv}nixos-enter --root $mountPoint -- chown -R "$user:$group" "$target"
          fi
        done

        ${lib.optionalString reproducible (rebuildBootPartitions + recordTouchedInodes)}
        umount -R /mnt

        ${lib.optionalString reproducible normaliseRootFilesystem}
        # Make sure resize2fs works. Note that resize2fs has stricter criteria for resizing than a normal
        # mount, so the `-c 0` and `-i 0` don't affect it. Setting it to `now` doesn't produce deterministic
        # output, of course, but we can fix that when/if we start making images deterministic.
        # In deterministic mode, this is fixed to 1970-01-01 (UNIX timestamp 0).
        # This two-step approach is necessary otherwise `tune2fs` will want a fresher filesystem to perform
        # some changes.
        ${lib.optionalString (fsType == "ext4") ''
          tune2fs -T now ${lib.optionalString deterministic "-U ${rootFSUID}"} -c 0 -i 0 $rootDisk
          ${lib.optionalString deterministic "tune2fs -f -T 19700101 $rootDisk"}
        ''}
      ''
  );
in
if onlyNixStore then
  pkgs.runCommand name { } (prepareImage + moveOrConvertImage + createHydraBuildProducts + postVM)
else
  buildImage
