{
  lib,
  stdenv,
  runCommand,
  symlinkJoin,

  # Build tools
  e2fsprogs,
  cpio,
  fakeroot,
  libfaketime,

  # Kernel
  linuxPackages,

  # Supermin (for static init binary)
  supermin,

  # libguestfs (for guestfsd binary and init script source)
  libguestfs,

  # Appliance root filesystem packages
  augeas,
  bash,
  btrfs-progs,
  bzip2,
  coreutils,
  cryptsetup,
  dhcpcd,
  diffutils,
  dosfstools,
  eudev,
  file,
  findutils,
  gawk,
  gnugrep,
  gnused,
  gnutar,
  gptfdisk,
  gzip,
  hivex,
  iproute2,
  kmod,
  less,
  libxml2,
  lsof,
  lvm2,
  mdadm,
  ntfs3g,
  parted,
  pciutils,
  procps,
  psmisc,
  rsync,
  strace,
  util-linux,
  xfsprogs,
  xz,
  zstd,
}:

let
  kernel = linuxPackages.kernel;
  guestfsd = libguestfs.guestfsd;

  appliancePackages = [
    augeas
    bash
    btrfs-progs
    bzip2
    coreutils
    cryptsetup
    dhcpcd
    diffutils
    dosfstools
    e2fsprogs
    eudev
    file
    findutils
    gawk
    gnugrep
    gnused
    gnutar
    gptfdisk
    gzip
    hivex
    iproute2
    kmod
    less
    libxml2
    lsof
    lvm2
    lvm2.bin
    mdadm
    ntfs3g
    parted
    pciutils
    procps
    psmisc
    rsync
    strace
    util-linux
    xfsprogs
    xz
    zstd
  ];

  # Merge all appliance packages for FHS symlinks.
  # The symlinks point into /nix/store; at runtime the VM accesses
  # them via a 9p mount of the host's store.
  mergedEnv = symlinkJoin {
    name = "libguestfs-appliance-nix-env";
    paths = appliancePackages ++ [ guestfsd ];
  };

  # Kernel modules needed to boot the appliance VM, in dependency order.
  # Includes virtio, SCSI, filesystem, device-mapper, and 9p modules.
  requiredModules = [
    # virtio transport
    "virtio_pci_legacy_dev"
    "virtio_pci_modern_dev"
    "virtio_ring"
    "virtio"
    "virtio_pci"
    # block devices
    "virtio_blk"
    "scsi_common"
    "scsi_mod"
    "virtio_scsi"
    "sd_mod"
    # communication & network
    "virtio_console"
    "failover"
    "net_failover"
    "virtio_net"
    # AF_PACKET (raw sockets) -- needed by dhcpcd for DHCP; CONFIG_PACKET=m
    "af_packet"
    # filesystems
    "mbcache"
    "ext2"
    "crc16"
    "jbd2"
    "ext4"
    # FAT/vFAT (for EFI and Windows partitions)
    # nls_iso8859-1 is the default FAT iocharset; must be present or mount fails
    "nls_iso8859-1"
    "nls_utf8"
    "nls_cp437"
    "nls_ascii"
    "fat"
    "vfat"
    # device mapper
    "dax"
    "dm-mod"
    # 9p (for mounting host /nix/store)
    "netfs"
    "9pnet"
    "9pnet_virtio"
    "9p"
  ];

in
stdenv.mkDerivation (finalAttrs: {
  pname = "libguestfs-appliance-nix";
  version = libguestfs.version;

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out
    cp ${kernel}/bzImage $out/kernel
    cp ${finalAttrs.initrd} $out/initrd
    cp ${finalAttrs.rootImage} $out/root
    echo "Fixed appliance built from NixOS packages (9p-backed)" > $out/README.fixed
  '';

  # Supermin with 9p nix-store mount support patched into its init binary.
  # The base supermin package is unmodified; this override only affects
  # the appliance built here.
  superminWithNix9p = supermin.overrideAttrs (prev: {
    outputs = [
      "out"
      "init"
    ];

    patches = (prev.patches or [ ]) ++ [
      # Mount a 9p "nix-store" share (if present) before chroot in the
      # ext2 init.  This lets Nix-built appliances access /nix/store via
      # virtio-9p instead of baking the full closure into the root image.
      ./nix-9p-init.patch
    ];

    postBuild = (prev.postBuild or "") + ''
      # Build the static init binary used in supermin ext2 initrds.
      cat > init/config.h <<CONF
      #define PACKAGE_VERSION "${prev.version}"
      #define MAJOR_IN_SYSMACROS 1
      CONF
      $CC -static -O2 -Iinit -o init/init init/init.c
    '';

    postInstall = (prev.postInstall or "") + ''
      install -Dm755 init/init $init/bin/init
    '';
  });

  # Initrd: supermin init binary + decompressed kernel modules.
  initrd =
    runCommand "libguestfs-appliance-nix-initrd"
      {
        nativeBuildInputs = [
          cpio
          xz
          zstd
        ];
      }
      ''
        mkdir -p initrd/{proc,sys,dev,root}
        cp ${finalAttrs.superminWithNix9p.init}/bin/init initrd/init

        kmodBase="${kernel.modules}/lib/modules/${kernel.modDirVersion}"

        : > initrd/modules
        for modName in ${lib.concatStringsSep " " requiredModules}; do
          modFile=$(find "$kmodBase/kernel" \
            -name "$modName.ko.xz" -o \
            -name "$modName.ko.zst" -o \
            -name "$modName.ko" \
            2>/dev/null | head -1)
          if [ -n "$modFile" ]; then
            case "$modFile" in
              *.xz) xz -dc "$modFile" > "initrd/$modName.ko" ;;
              *.zst) zstd -dc "$modFile" > "initrd/$modName.ko" ;;
              *) cp "$modFile" "initrd/$modName.ko" ;;
            esac
            echo "/$modName.ko" >> initrd/modules
          fi
        done

        (cd initrd && find . -print0 | sort -z | cpio --null -o -H newc --reproducible) \
          | gzip -9n > $out
      '';

  # Root ext2 image: just FHS skeleton + symlinks into /nix/store.
  # The actual store paths are mounted at runtime via 9p, so this
  # image is tiny (~1 MiB) and does not contain the Nix closure.
  rootImage = stdenv.mkDerivation {
    name = "libguestfs-appliance-nix-root";

    dontUnpack = true;

    nativeBuildInputs = [
      e2fsprogs.bin
      fakeroot
      libfaketime
    ];

    buildPhase = ''
      runHook preBuild

      mkdir -p rootfs/{etc/udev/rules.d,proc,sys,dev,tmp,var/tmp,var/lib,var/run,run,sysroot,nix/store,usr}
      chmod 1777 rootfs/tmp rootfs/var/tmp

      # FHS symlinks to the merged environment (resolved via 9p at runtime)
      ln -s ${mergedEnv}/bin rootfs/bin
      if [ -d ${mergedEnv}/sbin ]; then
        ln -s ${mergedEnv}/sbin rootfs/sbin
      else
        ln -s ${mergedEnv}/bin rootfs/sbin
      fi
      mkdir -p rootfs/usr
      ln -s ${mergedEnv}/bin rootfs/usr/bin
      if [ -d ${mergedEnv}/sbin ]; then
        ln -s ${mergedEnv}/sbin rootfs/usr/sbin
      else
        ln -s ${mergedEnv}/bin rootfs/usr/sbin
      fi

      for d in lib lib64 libexec share; do
        if [ -d ${mergedEnv}/$d ]; then
          ln -s ${mergedEnv}/$d rootfs/$d
          ln -s ${mergedEnv}/$d rootfs/usr/$d
        fi
      done

      install -m755 ${libguestfs.init}/bin/init rootfs/init
      install -m644 ${libguestfs.udev}/etc/udev/rules.d/99-guestfs-serial.rules rootfs/etc/udev/rules.d/
      ln -sf /proc/mounts rootfs/etc/mtab

      # eudev stores its rules under $out/var/lib/udev/rules.d, not
      # $out/lib/udev/rules.d, so udevd would not find them.  Symlink
      # them into /etc/udev/rules.d (which udevd does scan) so that the
      # persistent-storage, block, and other built-in rule sets are active.
      for f in ${mergedEnv}/var/lib/udev/rules.d/*.rules; do
        ln -s "$f" "rootfs/etc/udev/rules.d/$(basename "$f")"
      done

      # Image is tiny: just the skeleton, no Nix store closure
      echo "Creating ext2 image..."
      numInodes=$(find ./rootfs | wc -l)
      numDataBlocks=$(du -s -c -B 4096 --apparent-size ./rootfs | tail -1 | awk '{ print int($1 * 1.20) }')
      bytes=$((2 * 4096 * numInodes + 4096 * numDataBlocks))

      mebibyte=$(( 1024 * 1024 ))
      if (( bytes % mebibyte )); then
        bytes=$(( (bytes / mebibyte + 1) * mebibyte ))
      fi

      truncate -s $bytes root.img
      faketime -f "1970-01-01 00:00:01" fakeroot mkfs.ext2 -L appliance -d ./rootfs root.img

      export EXT2FS_NO_MTAB_OK=yes
      resize2fs -M root.img
      new_size=$(dumpe2fs -h root.img 2>/dev/null | awk -F: \
        '/Block count/{count=$2} /Block size/{size=$2} END{print (count*size+1*2^20)/size}')
      resize2fs root.img $new_size

      echo "Root image size: $(($(stat -c%s root.img) / 1024)) KiB"

      runHook postBuild
    '';

    installPhase = ''
      cp root.img $out
    '';
  };

  passthru = {
    inherit (finalAttrs) superminWithNix9p initrd rootImage;
  };

  meta = {
    description = "Nix-built VM appliance for libguestfs (9p-backed, small output)";
    homepage = "https://libguestfs.org";
    license = with lib.licenses; [
      gpl2Plus
      lgpl2Plus
    ];
    maintainers = with lib.maintainers; [ illustris ];
    platforms = [ "x86_64-linux" ];
    # Explicitly set so libguestfs can read appliance.meta.hydraPlatforms
    hydraPlatforms = [ "x86_64-linux" ];
  };
})
