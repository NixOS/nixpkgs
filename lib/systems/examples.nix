# These can be passed to nixpkgs as either the `localSystem` or
# `crossSystem`. They are put here for user convenience, but also used by cross
# tests and linux cross stdenv building, so handle with care!
{ lib }:
let platforms = import ./platforms.nix { inherit lib; }; in

rec {
  #
  # Linux
  #
  powernv = {
    config = "powerpc64le-unknown-linux-gnu";
    platform = platforms.powernv;
  };
  musl-power = {
    config = "powerpc64le-unknown-linux-musl";
    platform = platforms.powernv;
  };

  sheevaplug = rec {
    config = "armv5tel-unknown-linux-gnueabi";
    platform = platforms.sheevaplug;
  };

  raspberryPi = rec {
    config = "armv6l-unknown-linux-gnueabihf";
    platform = platforms.raspberrypi;
  };

  armv7l-hf-multiplatform = rec {
    config = "armv7a-unknown-linux-gnueabihf";
    platform = platforms.armv7l-hf-multiplatform;
  };

  aarch64-multiplatform = rec {
    config = "aarch64-unknown-linux-gnu";
    platform = platforms.aarch64-multiplatform;
  };

  armv5te-android-prebuilt = rec {
    config = "armv5tel-unknown-linux-androideabi";
    sdkVer = "21";
    ndkVer = "10e";
    platform = platforms.armv5te-android;
    useAndroidPrebuilt = true;
  };

  armv7a-android-prebuilt = rec {
    config = "armv7a-unknown-linux-androideabi";
    sdkVer = "24";
    ndkVer = "17";
    platform = platforms.armv7a-android;
    useAndroidPrebuilt = true;
  };

  aarch64-android-prebuilt = rec {
    config = "aarch64-unknown-linux-android";
    sdkVer = "24";
    ndkVer = "17";
    platform = platforms.aarch64-multiplatform;
    useAndroidPrebuilt = true;
  };

  scaleway-c1 = armv7l-hf-multiplatform // rec {
    platform = platforms.scaleway-c1;
    inherit (platform.gcc) fpu;
  };

  pogoplug4 = rec {
    config = "armv5tel-unknown-linux-gnueabi";
    platform = platforms.pogoplug4;
  };

  ben-nanonote = rec {
    config = "mipsel-unknown-linux-uclibc";
    platform = platforms.ben_nanonote;
  };

  fuloongminipc = rec {
    config = "mipsel-unknown-linux-gnu";
    platform = platforms.fuloong2f_n32;
  };

  muslpi = raspberryPi // {
    config = "armv6l-unknown-linux-musleabihf";
  };

  aarch64-multiplatform-musl = aarch64-multiplatform // {
    config = "aarch64-unknown-linux-musl";
  };

  musl64 = { config = "x86_64-unknown-linux-musl"; };
  musl32  = { config = "i686-unknown-linux-musl"; };

  riscv = bits: {
    config = "riscv${bits}-unknown-linux-gnu";
    platform = platforms.riscv-multiplatform bits;
  };
  riscv64 = riscv "64";
  riscv32 = riscv "32";


  #
  # Darwin
  #

  iphone64 = {
    config = "aarch64-apple-ios";
    # config = "aarch64-apple-darwin14";
    sdkVer = "10.2";
    xcodeVer = "8.2";
    xcodePlatform = "iPhoneOS";
    useiOSPrebuilt = true;
    platform = {};
  };

  iphone32 = {
    config = "armv7a-apple-ios";
    # config = "arm-apple-darwin10";
    sdkVer = "10.2";
    xcodeVer = "8.2";
    xcodePlatform = "iPhoneOS";
    useiOSPrebuilt = true;
    platform = {};
  };

  iphone64-simulator = {
    config = "x86_64-apple-ios";
    # config = "x86_64-apple-darwin14";
    sdkVer = "10.2";
    xcodeVer = "8.2";
    xcodePlatform = "iPhoneSimulator";
    useiOSPrebuilt = true;
    platform = {};
  };

  iphone32-simulator = {
    config = "i686-apple-ios";
    # config = "i386-apple-darwin11";
    sdkVer = "10.2";
    xcodeVer = "8.2";
    xcodePlatform = "iPhoneSimulator";
    useiOSPrebuilt = true;
    platform = {};
  };

  #
  # Windows
  #

  # 32 bit mingw-w64
  mingw32 = {
    config = "i686-pc-mingw32";
    libc = "msvcrt"; # This distinguishes the mingw (non posix) toolchain
    platform = {};
  };

  # 64 bit mingw-w64
  mingwW64 = {
    # That's the triplet they use in the mingw-w64 docs.
    config = "x86_64-pc-mingw32";
    libc = "msvcrt"; # This distinguishes the mingw (non posix) toolchain
    platform = {};
  };
}
