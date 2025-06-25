# Note: lib/systems/default.nix takes care of producing valid,
# fully-formed "platform" values (e.g. hostPlatform, buildPlatform,
# targetPlatform, etc) containing at least the minimal set of attrs
# required (see types.parsedPlatform in lib/systems/parse.nix).  This
# file takes an already-valid platform and further elaborates it with
# optional fields; currently these are: linux-kernel, gcc, and rustc.

{ lib }:
rec {
  pc = {
    linux-kernel = {
      baseConfig = "defconfig";
      # Build whatever possible as a module, if not stated in the extra config.
      autoModules = true;
      target = "bzImage";
    };
  };

  powernv = {
    linux-kernel = {
      baseConfig = "powernv_defconfig";
      target = "vmlinux";
      autoModules = true;
      # avoid driver/FS trouble arising from unusual page size
      extraConfig = ''
        PPC_64K_PAGES n
        PPC_4K_PAGES y

        ATA_SFF y
        VIRTIO_MENU y
      '';
    };
  };

  ##
  ## ARM
  ##

  armv5tel-multiplatform = {
    linux-kernel = {
      baseConfig = "multi_v5_defconfig";
      DTB = true;
      autoModules = true;
      preferBuiltin = true;
      target = "zImage";
    };
    gcc = {
      arch = "armv5te";
    };
  };

  raspberrypi = {
    linux-kernel = {
      baseConfig = "bcm2835_defconfig";
      DTB = true;
      autoModules = true;
      preferBuiltin = true;
      target = "zImage";
    };
    gcc = {
      # https://en.wikipedia.org/wiki/Raspberry_Pi#Specifications
      arch = "armv6kz";
      fpu = "vfpv2";
    };
  };

  # Legacy attribute, for compatibility with existing configs only.
  raspberrypi2 = armv7l-hf-multiplatform;

  # Nvidia Bluefield 2 (w. crypto support)
  bluefield2 = {
    gcc = {
      arch = "armv8-a+fp+simd+crc+crypto";
    };
  };

  zero-gravitas = {
    gcc = {
      fpu = "neon";
      cpu = "cortex-a9";
    };
  };

  zero-sugar = {
    gcc = {
      cpu = "cortex-a7";
      fpu = "neon-vfpv4";
      float-abi = "hard";
    };
  };

  # https://developer.android.com/ndk/guides/abis#v7a
  armv7a-android = {
    gcc = {
      arch = "armv7-a";
      float-abi = "softfp";
      fpu = "vfpv3-d16";
    };
  };

  armv7l-hf-multiplatform = {
    linux-kernel = {
      baseConfig = "defconfig";
      DTB = true;
      autoModules = true;
      preferBuiltin = true;
      target = "zImage";
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
      baseConfig = "defconfig";
      DTB = true;
      autoModules = true;
      preferBuiltin = true;
      extraConfig = ''
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

  apple-m1 = {
    gcc = {
      arch = "armv8.3-a+crypto+sha2+aes+crc+fp16+lse+simd+ras+rdm+rcpc";
      cpu = "apple-a13";
    };
  };

  ##
  ## MIPS
  ##

  ben_nanonote = {
    gcc = {
      arch = "mips32";
      float = "soft";
    };
  };

  fuloong2f_n32 = {
    gcc = {
      arch = "loongson2f";
      float = "hard";
      abi = "n32";
    };
  };

  # can execute on 32bit chip
  gcc_mips32r2_o32 = {
    gcc = {
      arch = "mips32r2";
      abi = "32";
    };
  };
  gcc_mips32r6_o32 = {
    gcc = {
      arch = "mips32r6";
      abi = "32";
    };
  };
  gcc_mips64r2_n32 = {
    gcc = {
      arch = "mips64r2";
      abi = "n32";
    };
  };
  gcc_mips64r6_n32 = {
    gcc = {
      arch = "mips64r6";
      abi = "n32";
    };
  };
  gcc_mips64r2_64 = {
    gcc = {
      arch = "mips64r2";
      abi = "64";
    };
  };
  gcc_mips64r6_64 = {
    gcc = {
      arch = "mips64r6";
      abi = "64";
    };
  };

  ##
  ## Other
  ##

  riscv-multiplatform = {
    linux-kernel = {
      target = "Image";
      autoModules = true;
      preferBuiltin = true;
      baseConfig = "defconfig";
      DTB = true;
    };
  };

  loongarch64-multiplatform = {
    gcc = {
      # https://github.com/loongson/la-softdev-convention/blob/master/la-softdev-convention.adoc#10-operating-system-package-build-requirements
      arch = "la64v1.0";
      strict-align = false;
      # Avoid text sections of large apps exceeding default code model
      # Will be default behavior in LLVM 21 and hopefully GCC16
      # https://github.com/loongson-community/discussions/issues/43
      # https://github.com/llvm/llvm-project/pull/132173
      cmodel = "medium";
    };
    linux-kernel = {
      target = "vmlinuz.efi";
      autoModules = true;
      preferBuiltin = true;
      baseConfig = "defconfig";
      DTB = true;
    };
  };

  # This function takes a minimally-valid "platform" and returns an
  # attrset containing zero or more additional attrs which should be
  # included in the platform in order to further elaborate it.
  select =
    platform:
    # x86
    if platform.isx86 then
      pc

    # ARM
    else if platform.isAarch32 then
      let
        version = platform.parsed.cpu.version or null;
      in
      if version == null then
        pc
      else if lib.versionOlder version "6" then
        armv5tel-multiplatform
      else if lib.versionOlder version "7" then
        raspberrypi
      else
        armv7l-hf-multiplatform

    else if platform.isAarch64 then
      if platform.isDarwin then apple-m1 else aarch64-multiplatform

    else if platform.isLoongArch64 then
      loongarch64-multiplatform

    else if platform.isRiscV then
      riscv-multiplatform

    else if platform.parsed.cpu == lib.systems.parse.cpuTypes.mipsel then
      (import ./examples.nix { inherit lib; }).mipsel-linux-gnu

    else if platform.parsed.cpu == lib.systems.parse.cpuTypes.powerpc64le then
      powernv

    else
      { };
}
