# These can be passed to nixpkgs as either the `localSystem` or
# `crossSystem`. They are put here for user convenience, but also used by cross
# tests and linux cross stdenv building, so handle with care!

let platforms = import ./platforms.nix; in

rec {
  #
  # Linux
  #

  sheevaplug = rec {
    config = "armv5tel-unknown-linux-gnueabi";
    bigEndian = false;
    arch = "armv5tel";
    float = "soft";
    withTLS = true;
    libc = "glibc";
    platform = platforms.sheevaplug;
    openssl.system = "linux-generic32";
    inherit (platform) gcc;
  };

  raspberryPi = rec {
    config = "armv6l-unknown-linux-gnueabihf";
    bigEndian = false;
    arch = "armv6l";
    float = "hard";
    fpu = "vfp";
    withTLS = true;
    libc = "glibc";
    platform = platforms.raspberrypi;
    openssl.system = "linux-generic32";
    inherit (platform) gcc;
  };

  armv7l-hf-multiplatform = rec {
    config = "arm-unknown-linux-gnueabihf";
    bigEndian = false;
    arch = "armv7-a";
    float = "hard";
    fpu = "vfpv3-d16";
    withTLS = true;
    libc = "glibc";
    platform = platforms.armv7l-hf-multiplatform;
    openssl.system = "linux-generic32";
    inherit (platform) gcc;
  };

  aarch64-multiplatform = rec {
    config = "aarch64-unknown-linux-gnu";
    bigEndian = false;
    arch = "aarch64";
    withTLS = true;
    libc = "glibc";
    platform = platforms.aarch64-multiplatform;
    inherit (platform) gcc;
  };

  scaleway-c1 = armv7l-hf-multiplatform // rec {
    platform = platforms.scaleway-c1;
    inherit (platform) gcc;
    inherit (gcc) fpu;
  };

  pogoplug4 = rec {
    arch = "armv5tel";
    config = "armv5tel-softfloat-linux-gnueabi";
    float = "soft";

    platform = platforms.pogoplug4;

    inherit (platform) gcc;
    libc = "glibc";

    withTLS = true;
    openssl.system = "linux-generic32";
  };

  fuloongminipc = rec {
    config = "mips64el-unknown-linux-gnu";
    bigEndian = false;
    arch = "mips";
    float = "hard";
    withTLS = true;
    libc = "glibc";
    platform = platforms.fuloong2f_n32;
    openssl.system = "linux-generic32";
    inherit (platform) gcc;
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
