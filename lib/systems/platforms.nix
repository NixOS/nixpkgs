{ lib }:
rec {
  pcBase = {
    name = "pc";
    kernelBaseConfig = "defconfig";
    # Build whatever possible as a module, if not stated in the extra config.
    kernelAutoModules = true;
    kernelTarget = "bzImage";
  };

  pc64 = pcBase // { kernelArch = "x86_64"; };

  pc32 = pcBase // { kernelArch = "i386"; };

  pc32_simplekernel = pc32 // {
    kernelAutoModules = false;
  };

  pc64_simplekernel = pc64 // {
    kernelAutoModules = false;
  };

  pogoplug4 = {
    name = "pogoplug4";

    gcc = {
      arch = "armv5te";
      float = "soft";
    };

    kernelMajor = "2.6";
    kernelBaseConfig = "multi_v5_defconfig";
    kernelArch = "arm";
    kernelAutoModules = false;
    kernelExtraConfig =
      ''
        # Ubi for the mtd
        MTD_UBI y
        UBIFS_FS y
        UBIFS_FS_XATTR y
        UBIFS_FS_ADVANCED_COMPR y
        UBIFS_FS_LZO y
        UBIFS_FS_ZLIB y
        UBIFS_FS_DEBUG n
      '';
    kernelMakeFlags = [ "LOADADDR=0x8000" ];
    kernelTarget = "uImage";
    # TODO reenable once manual-config's config actually builds a .dtb and this is checked to be working
    #kernelDTB = true;
  };

  sheevaplug = {
    name = "sheevaplug";
    kernelMajor = "2.6";
    kernelBaseConfig = "multi_v5_defconfig";
    kernelArch = "arm";
    kernelAutoModules = false;
    kernelExtraConfig = ''
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
    kernelMakeFlags = [ "LOADADDR=0x0200000" ];
    kernelTarget = "uImage";
    kernelDTB = true; # Beyond 3.10
    gcc = {
      arch = "armv5te";
      float = "soft";
    };
  };

  raspberrypi = {
    name = "raspberrypi";
    kernelMajor = "2.6";
    kernelBaseConfig = "bcmrpi_defconfig";
    kernelDTB = true;
    kernelArch = "arm";
    kernelAutoModules = false;
    kernelExtraConfig = ''
      BLK_DEV_RAM y
      BLK_DEV_INITRD y
      BLK_DEV_CRYPTOLOOP m
      BLK_DEV_DM m
      DM_CRYPT m
      MD y
      REISERFS_FS m
      BTRFS_FS y
      XFS_FS m
      JFS_FS y
      EXT4_FS y

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

      ZRAM m

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

      # nixos mounts some cgroup
      CGROUPS y

      # Latencytop
      LATENCYTOP y
    '';
    kernelTarget = "zImage";
    gcc = {
      arch = "armv6";
      fpu = "vfp";
      float = "hard";
      # TODO(@Ericson2314) what is this and is it a good idea? It was
      # used in some cross compilation examples but not others.
      #
      # abi = "aapcs-linux";
    };
  };

  raspberrypi2 = armv7l-hf-multiplatform // {
    name = "raspberrypi2";
    kernelBaseConfig = "bcm2709_defconfig";
    kernelDTB = true;
    kernelAutoModules = false;
    kernelExtraConfig = ''
      BLK_DEV_RAM y
      BLK_DEV_INITRD y
      BLK_DEV_CRYPTOLOOP m
      BLK_DEV_DM m
      DM_CRYPT m
      MD y
      REISERFS_FS m
      BTRFS_FS y
      XFS_FS m
      JFS_FS y
      EXT4_FS y

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

      ZRAM m

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

      # nixos mounts some cgroup
      CGROUPS y

      # Latencytop
      LATENCYTOP y

      # Disable the common config Xen, it doesn't build on ARM
      XEN? n
    '';
    kernelTarget = "zImage";
  };

  scaleway-c1 = armv7l-hf-multiplatform // {
    gcc = {
      cpu = "cortex-a9";
      fpu = "vfpv3";
      float = "hard";
    };
  };

  utilite = {
    name = "utilite";
    kernelMajor = "2.6";
    kernelBaseConfig = "multi_v7_defconfig";
    kernelArch = "arm";
    kernelAutoModules = false;
    kernelExtraConfig =
      ''
        # Ubi for the mtd
        MTD_UBI y
        UBIFS_FS y
        UBIFS_FS_XATTR y
        UBIFS_FS_ADVANCED_COMPR y
        UBIFS_FS_LZO y
        UBIFS_FS_ZLIB y
        UBIFS_FS_DEBUG n
      '';
    kernelMakeFlags = [ "LOADADDR=0x10800000" ];
    kernelTarget = "uImage";
    kernelDTB = true;
    gcc = {
      cpu = "cortex-a9";
      fpu = "neon";
      float = "hard";
    };
  };

  guruplug = sheevaplug // {
    # Define `CONFIG_MACH_GURUPLUG' (see
    # <http://kerneltrap.org/mailarchive/git-commits-head/2010/5/19/33618>)
    # and other GuruPlug-specific things.  Requires the `guruplug-defconfig'
    # patch.

    kernelBaseConfig = "guruplug_defconfig";
  };

  fuloong2f_n32 = {
    name = "fuloong2f_n32";
    kernelMajor = "2.6";
    kernelBaseConfig = "lemote2f_defconfig";
    kernelArch = "mips";
    kernelAutoModules = false;
    kernelExtraConfig = ''
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
    kernelTarget = "vmlinux";
    gcc = {
      arch = "loongson2f";
      abi = "n32";
    };
  };

  beaglebone = armv7l-hf-multiplatform // {
    name = "beaglebone";
    kernelBaseConfig = "bb.org_defconfig";
    kernelAutoModules = false;
    kernelExtraConfig = ""; # TBD kernel config
    kernelTarget = "zImage";
  };

  armv7l-hf-multiplatform = {
    name = "armv7l-hf-multiplatform";
    kernelMajor = "2.6"; # Using "2.6" enables 2.6 kernel syscalls in glibc.
    kernelBaseConfig = "multi_v7_defconfig";
    kernelArch = "arm";
    kernelDTB = true;
    kernelAutoModules = true;
    kernelPreferBuiltin = true;
    kernelTarget = "zImage";
    kernelExtraConfig = ''
      # Serial port for Raspberry Pi 3. Upstream forgot to add it to the ARMv7 defconfig.
      SERIAL_8250_BCM2835AUX y
      SERIAL_8250_EXTENDED y
      SERIAL_8250_SHARE_IRQ y

      # Fix broken sunxi-sid nvmem driver.
      TI_CPTS y

      # Hangs ODROID-XU4
      ARM_BIG_LITTLE_CPUIDLE n
    '';
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
      float = "hard";

      # For Raspberry Pi the 2 the best would be:
      #   cpu = "cortex-a7";
      #   fpu = "neon-vfpv4";
    };
  };

  aarch64-multiplatform = {
    name = "aarch64-multiplatform";
    kernelMajor = "2.6"; # Using "2.6" enables 2.6 kernel syscalls in glibc.
    kernelBaseConfig = "defconfig";
    kernelArch = "arm64";
    kernelDTB = true;
    kernelAutoModules = true;
    kernelPreferBuiltin = true;
    kernelExtraConfig = ''
      # Raspberry Pi 3 stuff. Not needed for kernels >= 4.10.
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
    kernelTarget = "Image";
    gcc = {
      arch = "armv8-a";
    };
  };

  riscv-multiplatform = bits: {
    name = "riscv-multiplatform";
    kernelArch = "riscv";
    bfdEmulation = "elf${bits}lriscv";
    kernelTarget = "vmlinux";
    kernelAutoModules = true;
    kernelBaseConfig = "defconfig";
    kernelExtraConfig = ''
      FTRACE n
      SERIAL_OF_PLATFORM y
    '';
  };

  selectBySystem = system: {
      "i686-linux" = pc32;
      "x86_64-linux" = pc64;
      "armv5tel-linux" = sheevaplug;
      "armv6l-linux" = raspberrypi;
      "armv7l-linux" = armv7l-hf-multiplatform;
      "aarch64-linux" = aarch64-multiplatform;
      "mipsel-linux" = fuloong2f_n32;
    }.${system} or pcBase;
}
