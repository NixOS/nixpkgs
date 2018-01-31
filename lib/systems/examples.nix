# These can be passed to nixpkgs as either the `localSystem` or
# `crossSystem`. They are put here for user convenience, but also used by cross
# tests and linux cross stdenv building, so handle with care!
{ lib }:
let platforms = import ./platforms.nix { inherit lib; }; in

rec {
  #
  # Linux
  #

  sheevaplug = rec {
    config = "armv5tel-unknown-linux-gnueabi";
    arch = "armv5tel";
    float = "soft";
    libc = "glibc";
    platform = platforms.sheevaplug;
  };

  raspberryPi = rec {
    config = "armv6l-unknown-linux-gnueabihf";
    arch = "armv6l";
    float = "hard";
    fpu = "vfp";
    libc = "glibc";
    platform = platforms.raspberrypi;
  };

  armv7l-hf-multiplatform = rec {
    config = "arm-unknown-linux-gnueabihf";
    arch = "armv7-a";
    float = "hard";
    fpu = "vfpv3-d16";
    libc = "glibc";
    platform = platforms.armv7l-hf-multiplatform;
  };

  aarch64-multiplatform = rec {
    config = "aarch64-unknown-linux-gnu";
    arch = "aarch64";
    libc = "glibc";
    platform = platforms.aarch64-multiplatform;
  };

  scaleway-c1 = armv7l-hf-multiplatform // rec {
    platform = platforms.scaleway-c1;
    inherit (platform.gcc) fpu;
  };

  pogoplug4 = rec {
    arch = "armv5tel";
    config = "armv5tel-unknown-linux-gnueabi";
    float = "soft";
    libc = "glibc";
    platform = platforms.pogoplug4;
  };

  fuloongminipc = rec {
    config = "mips64el-unknown-linux-gnu";
    arch = "mips";
    float = "hard";
    libc = "glibc";
    platform = platforms.fuloong2f_n32;
  };

  #
  # Darwin
  #

  iphone64 = {
    config = "aarch64-apple-darwin14";
    arch = "arm64";
    libc = "libSystem";
    platform = {};
  };

  iphone32 = {
    config = "arm-apple-darwin10";
    arch = "armv7-a";
    libc = "libSystem";
    platform = {};
  };

  #
  # Windows
  #

  # 32 bit mingw-w64
  mingw32 = {
    config = "i686-pc-mingw32";
    arch = "x86"; # Irrelevant
    libc = "msvcrt"; # This distinguishes the mingw (non posix) toolchain
    platform = {};
  };

  # 64 bit mingw-w64
  mingwW64 = {
    # That's the triplet they use in the mingw-w64 docs.
    config = "x86_64-pc-mingw32";
    arch = "x86_64"; # Irrelevant
    libc = "msvcrt"; # This distinguishes the mingw (non posix) toolchain
    platform = {};
  };
}
