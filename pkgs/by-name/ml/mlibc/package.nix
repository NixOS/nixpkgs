{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gtest,
  linuxHeaders,
}:

let
  cshim = fetchFromGitHub {
    owner = "managarm";
    repo = "cshim";
    rev = "2ec3cf90aac9207ce54eee70aa013910f5a6d243";
    sha256 = "sha256-uub+Yj4N7C6KZwPpBw87h3niWu2YiIFk13Cs8ozu1KY=";
  };
  cxxshim = fetchFromGitHub {
    owner = "managarm";
    repo = "cxxshim";
    rev = "6f146a41dda736572879fc524cf729eb193dc0a6";
    sha256 = "sha256-SSsS+WFR1Z8wT3fPxMpByWSc1WPnXAsyWHPyAH+86yA=";
  };
  frigg = fetchFromGitHub {
    owner = "managarm";
    repo = "frigg";
    rev = "1a415d6bef3aecabe5a4663f569ed71fa91bd603";
    sha256 = "sha256-KkffTJGBSI+bfGgyA8zrlsQo9GoA1s0p1YckgmvqYpE=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "mlibc";
  version = "5.0.0";

  src = fetchFromGitHub {
    owner = "managarm";
    repo = "mlibc";
    rev = "5.0.0";
    sha256 = "sha256-r9AqtsgV3ESApyX4WrwnCn1uj3ncTQ8tU9eZGEV8zSY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    gtest
  ];

  # patchelf adds entries it shouldn't to ld.so
  dontPatchELF = true;

  patches = [
    # These patches are cherry-picked commits from master to build with -z,now
    ./0001-rtld-improve-unexpected-dynamic-entry-logging.patch
    ./0002-rtld-ignore-supported-dt_flags.patch
  ];

  mesonBuildType = "release";
  mesonFlags = [
    "-Ddefault_library=both"
    "-Dlinux_kernel_headers=${linuxHeaders}/include"
  ];

  # Vendor-in required subprojects.
  # Shims are not required when building with a linux-mlibc compiler, but we
  # don't have one in nixpkgs yet and we need the shims to bootstrap mlibc.
  # Alternatively, we can install headers only and bootstrap a linux-mlibc
  # compiler with those headers, then compile with the linux-mlibc compiler.
  preConfigure = ''
    ln -sf ${cshim} $(pwd)/subprojects/cshim
    ln -sf ${cxxshim} $(pwd)/subprojects/cxxshim
    ln -sf ${frigg} $(pwd)/subprojects/frigg
  '';

  # This mlibc-gcc uses a specs file to wrap the host's one. It's a hack,
  # we don't use it.
  postInstall = ''
    rm $out/bin/mlibc-gcc $out/lib/mlibc-gcc.specs
  '';

  # The dynamic loader should never have a RPATH entry, no idea what keeps
  # adding it, but this hack should fix it.
  postFixup = ''
    patchelf --remove-rpath $out/lib/ld.so
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
