# RFC #46 specified the authoritative source of platform support tiers would be
# the Nixpkgs manual. Brief discussion in
# [NixOS/rfcs#113](https://github.com/NixOS/rfcs/pull/113) indicated that code
# is often a better source of truth than documentation. This file is intented
# to be exactly that.

{ lib }:

let inherit (lib.systems.examples)
      aarch64-android
      aarch64-darwin
      aarch64-embedded
      aarch64-multiplatform
      arm-embedded
      armv7a-android-prebuilt
      armv7l-hf-multiplatform
      avr
      gnu32
      gnu64
      i686-embedded
      mingw32
      mingwW64
      mipsel-linux-gnu
      musl64
      powernv
      ppc-embedded
      ppc64
      ppcle-embedded
      raspberryPi
      riscv64
      sheevaplug
      wasm32
      x86_64-darwin
      x86_64-embedded
      x86_64-freebsd;
in {
  tier1 = [ gnu64 ];

  tier2 = [ aarch64-multiplatform x86_64-darwin ];

  # Missing:
  # armv8*-linux, gcc + glibc
  # armv{6,7,8}*-linux, gcc + glibc, cross-compilation
  # aarch64-linux, gcc + glibc, cross-compilation
  tier3 = [ armv7l-hf-multiplatform gnu32 mipsel-linux-gnu musl64 raspberryPi ];

  # Missing:
  # x86_64-linux, gcc+musl — static
  # x86_64-linux, clang+glibc
  # x86_64-linux, clang+glibc — llvm linker
  # x86_64-linux — Android
  # armv8-linux — Android
  tier4 = [
    aarch64-android
    aarch64-embedded
    arm-embedded
    armv7a-android-prebuilt # Questionable due to the prebuiltness
    avr
    i686-embedded # i686-none?
    mingw32
    mingwW64
    ppc-embedded
    ppcle-embedded
    x86_64-embedded # x86_64-none?
  ];

  # Missing:
  # x86_64-linux, gcc+glibc — static
  # x86_64-linux, gcc+glibc — llvm linker
  tier5 = [];

  tier6 = [ powernv wasm32 ];

  # Missing:
  # i686-darwin
  # i686-solaris
  # x86_64-illumos
  tier7 = [ aarch64-darwin sheevaplug ppc64 riscv64 x86_64-freebsd ];
}
