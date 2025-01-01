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
    owner = "osdev0";
    repo = "freestnd-c-hdrs";
    rev = "910d752825a08421432ed71329ac140dd608e33a";
    sha256 = "sha256-aLnbiST4WjTnkjEUus+ijevbB2ml4jUOXQUnMp95iAE=";
  };
  freestnd-cxx-hdrs = fetchFromGitHub {
    owner = "osdev0";
    repo = "freestnd-cxx-hdrs";
    rev = "2b2345a2fc8edced19983130a1f17164fd2cbdfe";
    sha256 = "sha256-BBn6mglVtfEtPldb1f2BiWfMeemMHzrY1c+38XOMRRE=";
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
    rev = "942c050f53cf12c796302748c5ecb260a6c82884";
    sha256 = "sha256-2N+nFjoc5+OwKuKf2mwM3KgTnUrV8Q+qHiPmST6EKQ0=";
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
      licenses.bsd0 # cshim
      licenses.mit # mlibc, cxxshim, frigg, parts of musl
    ];
    maintainers = [
      maintainers.sanana
    ];
  };
})
