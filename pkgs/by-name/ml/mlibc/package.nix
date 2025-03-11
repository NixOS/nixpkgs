{
  lib,
  buildPackages,
  stdenvNoLibc,
  fetchFromGitHub,
  ninja,
  pkg-config,
  linuxHeaders,
}:

let
  freestnd-c-hdrs = fetchFromGitHub {
    owner = "lzcunt";
    repo = "freestnd-c-hdrs";
    rev = "4220bc39b8231d7fa318a09b1ed3e673ec07da16";
    sha256 = "sha256-AIZDnk1Qe4gRBNd8/nsdnRypYVf/iLFDf+EcGbvUfOw=";
  };
  freestnd-cxx-hdrs = fetchFromGitHub {
    owner = "lzcunt";
    repo = "freestnd-cxx-hdrs";
    rev = "5f584df501c5e2665a6414ceb3451b9ee26f8d40";
    sha256 = "sha256-tMh/NKzLFjM5aVsLnYrJcTW+Ddgs8LQr8P8P+jtJsuA=";
  };
  frigg = fetchFromGitHub {
    owner = "managarm";
    repo = "frigg";
    rev = "307e9361acb49e7d9e5e7f62a1b48de66974d8f4";
    sha256 = "sha256-X5ZcXYe7H3Qrec/LD1mmHJ13ZKRutPjoPjg6j/MMFKM=";
  };
in
stdenvNoLibc.mkDerivation (finalAttrs: {
  pname = "mlibc";
  version = "5.0.0-unstable-2025-01-12";

  src = fetchFromGitHub {
    # temporarily points to my fork of mlibc
    owner = "lzcunt";
    repo = "mlibc";
    rev = "501b87c6c2701f74243f0750d2ce6b5031ac8609";
    sha256 = "sha256-7EYap5V34v2BtX0C6DfsDHyX7Nmgp8SCrocYlrUXa+0=";
  };

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [
    (buildPackages.meson.override { python3 = buildPackages.__splicedPackages.python3Minimal; })
    ninja
    pkg-config
  ];

  # patchelf adds entries it shouldn't to ld.so
  dontPatchELF = true;

  mesonBuildType = "release";
  mesonFlags = [
    "-Ddefault_library=both"
    "-Dlinux_kernel_headers=${linuxHeaders}/include"
    "-Dbuild_tests=false"
  ];

  preConfigure = ''
    # Vendor-in required subprojects.
    # freestnd-*-hdrs are not required when building with a linux-mlibc
    # compiler, but currently, we need the freestanding headers to bootstrap.
    # Alternatively, we could install headers only and bootstrap a linux-mlibc
    # compiler with those headers, then compile with the linux-mlibc compiler.
    ln -sf ${freestnd-c-hdrs} $(pwd)/subprojects/freestnd-c-hdrs
    ln -sf ${freestnd-cxx-hdrs} $(pwd)/subprojects/freestnd-cxx-hdrs
    ln -sf ${frigg} $(pwd)/subprojects/frigg
  '';

  postInstall = ''
    # This mlibc-gcc uses a specs file to wrap the host's one. It's a hack,
    # we don't use it.
    rm $out/bin/mlibc-gcc $out/lib/mlibc-gcc.specs

    # some mlibc headers depend on linux headers
    # scsi/* and linux/libc-compat.h are provided by mlibc
    ln -s $(ls -d ${linuxHeaders}/include/* | grep -Pv "scsi$|linux$") $dev/include
    ln -s $(ls -d ${linuxHeaders}/include/linux/* | grep -v "libc-compat.h$") $dev/include/linux
  '';

  postFixup = ''
    # The dynamic loader should never have a RPATH entry, let's remove it.
    # Normally NIX_DONT_SET_RPATH would be used but it breaks meson's sanity
    # checks, so we're doing it manually.
    if [ -f $out/lib/ld.so ]; then
      patchelf --remove-rpath $out/lib/ld.so
    fi
  '';

  outputs = [
    "out"
    "dev"
  ];

  meta = with lib; {
    description = "Portable C standard library";
    platforms = [
      # These are the only platforms supported by both mlibc and nixpkgs
      "aarch64-linux"
      "i686-linux"
      "m68k-linux"
      "riscv64-linux"
      "x86_64-linux"
    ];
    license = [
      licenses.gpl3Plus # freestnd-c/cxx-hdrs (with GCC runtime exception)
      licenses.mit # mlibc, frigg, parts of musl
    ];
    maintainers = [
      maintainers.sanana
    ];
  };
})
