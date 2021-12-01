# These can be passed to nixpkgs as either the `localSystem` or
# `crossSystem`. They are put here for user convenience, but also used by cross
# tests and linux cross stdenv building, so handle with care!
{ lib }:
let
  platforms = import ./platforms.nix { inherit lib; };

  riscv = bits: {
    config = "riscv${bits}-unknown-linux-gnu";
  };
in

rec {
  #
  # Linux
  #
  powernv = {
    config = "powerpc64le-unknown-linux-gnu";
  };
  musl-power = {
    config = "powerpc64le-unknown-linux-musl";
  };

  ppc64 = {
    config = "powerpc64-unknown-linux-gnu";
    gcc = { abi = "elfv2"; }; # for gcc configuration
  };
  ppc64-musl = {
    config = "powerpc64-unknown-linux-musl";
    gcc = { abi = "elfv2"; }; # for gcc configuration
  };

  sheevaplug = {
    config = "armv5tel-unknown-linux-gnueabi";
  } // platforms.sheevaplug;

  raspberryPi = {
    config = "armv6l-unknown-linux-gnueabihf";
  } // platforms.raspberrypi;

  remarkable1 = {
    config = "armv7l-unknown-linux-gnueabihf";
  } // platforms.zero-gravitas;

  remarkable2 = {
    config = "armv7l-unknown-linux-gnueabihf";
  } // platforms.zero-sugar;

  armv7l-hf-multiplatform = {
    config = "armv7l-unknown-linux-gnueabihf";
  };

  aarch64-multiplatform = {
    config = "aarch64-unknown-linux-gnu";
  };

  armv7a-android-prebuilt = {
    config = "armv7a-unknown-linux-androideabi";
    rustc.config = "armv7-linux-androideabi";
    sdkVer = "29";
    ndkVer = "21";
    useAndroidPrebuilt = true;
  } // platforms.armv7a-android;

  aarch64-android-prebuilt = {
    config = "aarch64-unknown-linux-android";
    rustc.config = "aarch64-linux-android";
    sdkVer = "29";
    ndkVer = "21";
    useAndroidPrebuilt = true;
  };

  aarch64-android = {
    config = "aarch64-unknown-linux-android";
    sdkVer = "30";
    ndkVer = "21";
    libc = "bionic";
    useAndroidPrebuilt = false;
    useLLVM = true;
  };

  scaleway-c1 = armv7l-hf-multiplatform // platforms.scaleway-c1;

  pogoplug4 = {
    config = "armv5tel-unknown-linux-gnueabi";
  } // platforms.pogoplug4;

  ben-nanonote = {
    config = "mipsel-unknown-linux-uclibc";
  } // platforms.ben_nanonote;

  fuloongminipc = {
    config = "mipsel-unknown-linux-gnu";
  } // platforms.fuloong2f_n32;

  muslpi = raspberryPi // {
    config = "armv6l-unknown-linux-musleabihf";
  };

  aarch64-multiplatform-musl = {
    config = "aarch64-unknown-linux-musl";
  };

  gnu64 = { config = "x86_64-unknown-linux-gnu"; };
  gnu32  = { config = "i686-unknown-linux-gnu"; };

  musl64 = { config = "x86_64-unknown-linux-musl"; };
  musl32  = { config = "i686-unknown-linux-musl"; };

  riscv64 = riscv "64";
  riscv32 = riscv "32";

  riscv64-embedded = {
    config = "riscv64-none-elf";
    libc = "newlib";
  };

  riscv32-embedded = {
    config = "riscv32-none-elf";
    libc = "newlib";
  };

  mmix = {
    config = "mmix-unknown-mmixware";
    libc = "newlib";
  };

  msp430 = {
    config = "msp430-elf";
    libc = "newlib";
  };

  avr = {
    config = "avr";
  };

  vc4 = {
    config = "vc4-elf";
    libc = "newlib";
  };

  or1k = {
    config = "or1k-elf";
    libc = "newlib";
  };

  m68k = {
    config = "m68k-unknown-linux-gnu";
  };

  s390 = {
    config = "s390-unknown-linux-gnu";
  };

  s390x = {
    config = "s390x-unknown-linux-gnu";
  };

  arm-embedded = {
    config = "arm-none-eabi";
    libc = "newlib";
  };
  armhf-embedded = {
    config = "arm-none-eabihf";
    libc = "newlib";
    # GCC8+ does not build without this
    # (https://www.mail-archive.com/gcc-bugs@gcc.gnu.org/msg552339.html):
    gcc = {
      arch = "armv5t";
      fpu = "vfp";
    };
  };

  aarch64-embedded = {
    config = "aarch64-none-elf";
    libc = "newlib";
  };

  aarch64be-embedded = {
    config = "aarch64_be-none-elf";
    libc = "newlib";
  };

  ppc-embedded = {
    config = "powerpc-none-eabi";
    libc = "newlib";
  };

  ppcle-embedded = {
    config = "powerpcle-none-eabi";
    libc = "newlib";
  };

  i686-embedded = {
    config = "i686-elf";
    libc = "newlib";
  };

  x86_64-embedded = {
    config = "x86_64-elf";
    libc = "newlib";
  };

  #
  # Redox
  #

  x86_64-unknown-redox = {
    config = "x86_64-unknown-redox";
    libc = "relibc";
  };

  #
  # Darwin
  #

  iphone64 = {
    config = "aarch64-apple-ios";
    # config = "aarch64-apple-darwin14";
    sdkVer = "14.3";
    xcodeVer = "12.3";
    xcodePlatform = "iPhoneOS";
    useiOSPrebuilt = true;
  };

  iphone32 = {
    config = "armv7a-apple-ios";
    # config = "arm-apple-darwin10";
    sdkVer = "14.3";
    xcodeVer = "12.3";
    xcodePlatform = "iPhoneOS";
    useiOSPrebuilt = true;
  };

  iphone64-simulator = {
    config = "x86_64-apple-ios";
    # config = "x86_64-apple-darwin14";
    sdkVer = "14.3";
    xcodeVer = "12.3";
    xcodePlatform = "iPhoneSimulator";
    darwinPlatform = "ios-simulator";
    useiOSPrebuilt = true;
  };

  iphone32-simulator = {
    config = "i686-apple-ios";
    # config = "i386-apple-darwin11";
    sdkVer = "14.3";
    xcodeVer = "12.3";
    xcodePlatform = "iPhoneSimulator";
    darwinPlatform = "ios-simulator";
    useiOSPrebuilt = true;
  };

  aarch64-darwin = {
    config = "aarch64-apple-darwin";
    xcodePlatform = "MacOSX";
    platform = {};
  };

  x86_64-darwin = {
    config = "x86_64-apple-darwin";
    xcodePlatform = "MacOSX";
    platform = {};
  };

  #
  # Windows
  #

  # 32 bit mingw-w64
  mingw32 = {
    config = "i686-w64-mingw32";
    libc = "msvcrt"; # This distinguishes the mingw (non posix) toolchain
  };

  # 64 bit mingw-w64
  mingwW64 = {
    # That's the triplet they use in the mingw-w64 docs.
    config = "x86_64-w64-mingw32";
    libc = "msvcrt"; # This distinguishes the mingw (non posix) toolchain
  };

  # BSDs

  amd64-netbsd = lib.warn "The amd64-netbsd system example is deprecated. Use x86_64-netbsd instead." x86_64-netbsd;

  x86_64-netbsd = {
    config = "x86_64-unknown-netbsd";
    libc = "nblibc";
  };

  x86_64-netbsd-llvm = {
    config = "x86_64-unknown-netbsd";
    libc = "nblibc";
    useLLVM = true;
  };

  #
  # WASM
  #

  wasi32 = {
    config = "wasm32-unknown-wasi";
    useLLVM = true;
  };

  # Ghcjs
  ghcjs = {
    config = "js-unknown-ghcjs";
  };
}
