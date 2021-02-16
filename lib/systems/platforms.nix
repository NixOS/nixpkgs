{ lib }:
rec {
  pc = {
    linux-kernel = {
      name = "pc";

      baseConfig = "defconfig";
      # Build whatever possible as a module, if not stated in the extra config.
      autoModules = true;
      target = "bzImage";
    };
  };

  pc_simplekernel = lib.recursiveUpdate pc {
    linux-kernel.autoModules = false;
  };

  powernv = {
    linux-kernel = {
      name = "PowerNV";

      baseConfig = "powernv_defconfig";
      target = "zImage";
      installTarget = "install";
      file = "vmlinux";
      autoModules = true;
      # avoid driver/FS trouble arising from unusual page size
      extraConfig = ''
        PPC_64K_PAGES n
        PPC_4K_PAGES y
        IPV6 y
      '';
    };
  };

  ##
  ## ARM
  ##

  pogoplug4 = {
    linux-kernel = {
      name = "pogoplug4";

      baseConfig = "multi_v5_defconfig";
      autoModules = false;
      extraConfig = ''
        # Ubi for the mtd
        MTD_UBI y
        UBIFS_FS y
        UBIFS_FS_XATTR y
        UBIFS_FS_ADVANCED_COMPR y
        UBIFS_FS_LZO y
        UBIFS_FS_ZLIB y
        UBIFS_FS_DEBUG n
      '';
      makeFlags = [ "LOADADDR=0x8000" ];
      target = "uImage";
      # TODO reenable once manual-config's config actually builds a .dtb and this is checked to be working
      #DTB = true;
    };
    gcc = {
      arch = "armv5te";
    };
  };

  sheevaplug = {
    linux-kernel = {
      name = "sheevaplug";

      baseConfig = "multi_v5_defconfig";
      autoModules = false;
      extraConfig = ''
        BLK_DEV_RAM y
        BLK_DEV_INITRD y
        BLK_DEV_CRYPTOLOOP m
        BLK_DEV_DM m
        DM_CRYPT m
        MD y
        REISERFS_FS m
        BTRFS_FS m
        XFS_FS m
        JFS_FS m
        EXT4_FS m
        USB_STORAGE_CYPRESS_ATACB m

        # mv cesa requires this sw fallback, for mv-sha1
        CRYPTO_SHA1 y
        # Fast crypto
        CRYPTO_TWOFISH y
        CRYPTO_TWOFISH_COMMON y
        CRYPTO_BLOWFISH y
        CRYPTO_BLOWFISH_COMMON y

        IP_PNP y
        IP_PNP_DHCP y
        NFS_FS y
        ROOT_NFS y
        TUN m
        NFS_V4 y
        NFS_V4_1 y
        NFS_FSCACHE y
        NFSD m
        NFSD_V2_ACL y
        NFSD_V3 y
        NFSD_V3_ACL y
        NFSD_V4 y
        NETFILTER y
        IP_NF_IPTABLES y
        IP_NF_FILTER y
        IP_NF_MATCH_ADDRTYPE y
        IP_NF_TARGET_LOG y
        IP_NF_MANGLE y
        IPV6 m
        VLAN_8021Q m

        CIFS y
        CIFS_XATTR y
        CIFS_POSIX y
        CIFS_FSCACHE y
        CIFS_ACL y

        WATCHDOG y
        WATCHDOG_CORE y
        ORION_WATCHDOG m

        ZRAM m
        NETCONSOLE m

        # Disable OABI to have seccomp_filter (required for systemd)
        # https://github.com/raspberrypi/firmware/issues/651
        OABI_COMPAT n

        # Fail to build
        DRM n
        SCSI_ADVANSYS n
        USB_ISP1362_HCD n
        SND_SOC n
        SND_ALI5451 n
        FB_SAVAGE n
        SCSI_NSP32 n
        ATA_SFF n
        SUNGEM n
        IRDA n
        ATM_HE n
        SCSI_ACARD n
        BLK_DEV_CMD640_ENHANCED n

        FUSE_FS m

        # systemd uses cgroups
        CGROUPS y

        # Latencytop
        LATENCYTOP y

        # Ubi for the mtd
        MTD_UBI y
        UBIFS_FS y
        UBIFS_FS_XATTR y
        UBIFS_FS_ADVANCED_COMPR y
        UBIFS_FS_LZO y
        UBIFS_FS_ZLIB y
        UBIFS_FS_DEBUG n

        # Kdb, for kernel troubles
        KGDB y
        KGDB_SERIAL_CONSOLE y
        KGDB_KDB y
      '';
      makeFlags = [ "LOADADDR=0x0200000" ];
      target = "uImage";
      DTB = true; # Beyond 3.10
    };
    gcc = {
      arch = "armv5te";
    };
  };

  raspberrypi = {
    linux-kernel = {
      name = "raspberrypi";

      baseConfig = "bcm2835_defconfig";
      DTB = true;
      autoModules = true;
      preferBuiltin = true;
      extraConfig = ''
        # Disable OABI to have seccomp_filter (required for systemd)
        # https://github.com/raspberrypi/firmware/issues/651
        OABI_COMPAT n
      '';
      target = "zImage";
    };
    gcc = {
      arch = "armv6";
      fpu = "vfp";
    };
  };

  # Legacy attribute, for compatibility with existing configs only.
  raspberrypi2 = armv7l-hf-multiplatform;

  zero-gravitas = {
    linux-kernel = {
      name = "zero-gravitas";

      baseConfig = "zero-gravitas_defconfig";
      # Target verified by checking /boot on reMarkable 1 device
      target = "zImage";
      autoModules = false;
      DTB = true;
    };
    gcc = {
      fpu = "neon";
      cpu = "cortex-a9";
    };
  };

  zero-sugar = {
    linux-kernel = {
      name = "zero-sugar";

      baseConfig = "zero-sugar_defconfig";
      DTB = true;
      autoModules = false;
      preferBuiltin = true;
      target = "zImage";
    };
    gcc = {
      cpu = "cortex-a7";
      fpu = "neon-vfpv4";
      float-abi = "hard";
    };
  };

  scaleway-c1 = lib.recursiveUpdate armv7l-hf-multiplatform {
    gcc = {
      cpu = "cortex-a9";
      fpu = "vfpv3";
    };
  };

  utilite = {
    linux-kernel = {
      name = "utilite";
      maseConfig = "multi_v7_defconfig";
      autoModules = false;
      extraConfig = ''
        # Ubi for the mtd
        MTD_UBI y
        UBIFS_FS y
        UBIFS_FS_XATTR y
        UBIFS_FS_ADVANCED_COMPR y
        UBIFS_FS_LZO y
        UBIFS_FS_ZLIB y
        UBIFS_FS_DEBUG n
      '';
      makeFlags = [ "LOADADDR=0x10800000" ];
      target = "uImage";
      DTB = true;
    };
    gcc = {
      cpu = "cortex-a9";
      fpu = "neon";
    };
  };

  guruplug = lib.recursiveUpdate sheevaplug {
    # Define `CONFIG_MACH_GURUPLUG' (see
    # <http://kerneltrap.org/mailarchive/git-commits-head/2010/5/19/33618>)
    # and other GuruPlug-specific things.  Requires the `guruplug-defconfig'
    # patch.
    linux-kernel.baseConfig = "guruplug_defconfig";
  };

  beaglebone = lib.recursiveUpdate armv7l-hf-multiplatform {
    linux-kernel = {
      name = "beaglebone";
      baseConfig = "bb.org_defconfig";
      autoModules = false;
      extraConfig = ""; # TBD kernel config
      target = "zImage";
    };
  };

  # https://developer.android.com/ndk/guides/abis#v7a
  armv7a-android = {
    linux-kernel.name = "armeabi-v7a";
    gcc = {
      arch = "armv7-a";
      float-abi = "softfp";
      fpu = "vfpv3-d16";
    };
  };

  armv7l-hf-multiplatform = {
    linux-kernel = {
      name = "armv7l-hf-multiplatform";
      Major = "2.6"; # Using "2.6" enables 2.6 kernel syscalls in glibc.
      baseConfig = "multi_v7_defconfig";
      DTB = true;
      autoModules = true;
      preferBuiltin = true;
      target = "zImage";
      extraConfig = ''
        # Serial port for Raspberry Pi 3. Upstream forgot to add it to the ARMv7 defconfig.
        SERIAL_8250_BCM2835AUX y
        SERIAL_8250_EXTENDED y
        SERIAL_8250_SHARE_IRQ y

        # Fix broken sunxi-sid nvmem driver.
        TI_CPTS y

        # Hangs ODROID-XU4
        ARM_BIG_LITTLE_CPUIDLE n

        # Disable OABI to have seccomp_filter (required for systemd)
        # https://github.com/raspberrypi/firmware/issues/651
        OABI_COMPAT n
      '';
    };
    gcc = {
      # Some table about fpu flags:
      # http://community.arm.com/servlet/JiveServlet/showImage/38-1981-3827/blogentry-103749-004812900+1365712953_thumb.png
      # Cortex-A5: -mfpu=neon-fp16
      # Cortex-A7 (rpi2): -mfpu=neon-vfpv4
      # Cortex-A8 (beaglebone): -mfpu=neon
      # Cortex-A9: -mfpu=neon-fp16
      # Cortex-A15: -mfpu=neon-vfpv4

      # More about FPU:
      # https://wiki.debian.org/ArmHardFloatPort/VfpComparison

      # vfpv3-d16 is what Debian uses and seems to be the best compromise: NEON is not supported in e.g. Scaleway or Tegra 2,
      # and the above page suggests NEON is only an improvement with hand-written assembly.
      arch = "armv7-a";
      fpu = "vfpv3-d16";

      # For Raspberry Pi the 2 the best would be:
      #   cpu = "cortex-a7";
      #   fpu = "neon-vfpv4";
    };
  };

  aarch64-multiplatform = {
    linux-kernel = {
      name = "aarch64-multiplatform";
      baseConfig = "defconfig";
      DTB = true;
      autoModules = true;
      preferBuiltin = true;
      extraConfig = ''
        # Raspberry Pi 3 stuff. Not needed for   s >= 4.10.
        ARCH_BCM2835 y
        BCM2835_MBOX y
        BCM2835_WDT y
        RASPBERRYPI_FIRMWARE y
        RASPBERRYPI_POWER y
        SERIAL_8250_BCM2835AUX y
        SERIAL_8250_EXTENDED y
        SERIAL_8250_SHARE_IRQ y

        # Cavium ThunderX stuff.
        PCI_HOST_THUNDER_ECAM y

        # Nvidia Tegra stuff.
        PCI_TEGRA y

        # The default (=y) forces us to have the XHCI firmware available in initrd,
        # which our initrd builder can't currently do easily.
        USB_XHCI_TEGRA m
      '';
      target = "Image";
    };
    gcc = {
      arch = "armv8-a";
    };
  };

  ##
  ## MIPS
  ##

  ben_nanonote = {
    linux-kernel = {
      name = "ben_nanonote";
    };
    gcc = {
      arch = "mips32";
      float = "soft";
    };
  };

  fuloong2f_n32 = {
    linux-kernel = {
      name = "fuloong2f_n32";
      baseConfig = "lemote2f_defconfig";
      autoModules = false;
      extraConfig = ''
        MIGRATION n
        COMPACTION n

        # nixos mounts some cgroup
        CGROUPS y

        BLK_DEV_RAM y
        BLK_DEV_INITRD y
        BLK_DEV_CRYPTOLOOP m
        BLK_DEV_DM m
        DM_CRYPT m
        MD y
        REISERFS_FS m
        EXT4_FS m
        USB_STORAGE_CYPRESS_ATACB m

        IP_PNP y
        IP_PNP_DHCP y
        IP_PNP_BOOTP y
        NFS_FS y
        ROOT_NFS y
        TUN m
        NFS_V4 y
        NFS_V4_1 y
        NFS_FSCACHE y
        NFSD m
        NFSD_V2_ACL y
        NFSD_V3 y
        NFSD_V3_ACL y
        NFSD_V4 y

        # Fail to build
        DRM n
        SCSI_ADVANSYS n
        USB_ISP1362_HCD n
        SND_SOC n
        SND_ALI5451 n
        FB_SAVAGE n
        SCSI_NSP32 n
        ATA_SFF n
        SUNGEM n
        IRDA n
        ATM_HE n
        SCSI_ACARD n
        BLK_DEV_CMD640_ENHANCED n

        FUSE_FS m

        # Needed for udev >= 150
        SYSFS_DEPRECATED_V2 n

        VGA_CONSOLE n
        VT_HW_CONSOLE_BINDING y
        SERIAL_8250_CONSOLE y
        FRAMEBUFFER_CONSOLE y
        EXT2_FS y
        EXT3_FS y
        REISERFS_FS y
        MAGIC_SYSRQ y

        # The kernel doesn't boot at all, with FTRACE
        FTRACE n
      '';
      target = "vmlinux";
    };
    gcc = {
      arch = "loongson2f";
      float = "hard";
      abi = "n32";
    };
  };

  ##
  ## Other
  ##

  riscv-multiplatform = {
    linux-kernel = {
      name = "riscv-multiplatform";
      target = "vmlinux";
      autoModules = true;
      baseConfig = "defconfig";
      extraConfig = ''
        FTRACE n
        SERIAL_OF_PLATFORM y
      '';
    };
  };

  select = platform:
    # x86
    /**/ if platform.isx86 then pc

    # ARM
    else if platform.isAarch32 then let
      version = platform.parsed.cpu.version or null;
      in     if version == null then pc
        else if lib.versionOlder version "6" then sheevaplug
        else if lib.versionOlder version "7" then raspberrypi
        else armv7l-hf-multiplatform
    else if platform.isAarch64 then aarch64-multiplatform

    else if platform.isRiscV then riscv-multiplatform

    else if platform.parsed.cpu == lib.systems.parse.cpuTypes.mipsel then fuloong2f_n32

    else if platform.parsed.cpu == lib.systems.parse.cpuTypes.powerpc64le then powernv

    else pc;
}
