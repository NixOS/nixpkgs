{
  lib,
  cmake,
  fetchFromGitHub,
  gcc12Stdenv,
  gettext,
  libGL,
  libGLU,
  libaio,
  libpcap,
  libpng,
  libxml2,
  mkLibretroCore,
  pkg-config,
  xxd,
  xz,
}:
mkLibretroCore {
  core = "pcsx2";
  version = "0-unstable-2023-01-30";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "lrps2";
    rev = "f3c8743d6a42fe429f703b476fecfdb5655a98a9";
    hash = "sha256-0piCNWX7QbZ58KyTlWp4h1qLxXpi1z6ML8sBHMTvCY4=";
  };

  extraNativeBuildInputs = [
    cmake
    gettext
    pkg-config
  ];
  extraBuildInputs = [
    libaio
    libGL
    libGLU
    libpcap
    libpng
    libxml2
    xz
    xxd
  ];
  makefile = "Makefile";
  cmakeFlags = [ "-DLIBRETRO=ON" ];
  # remove ccache
  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail "ccache" ""
  '';
  postBuild = "cd pcsx2";
  # causes redefinition of _FORTIFY_SOURCE
  hardeningDisable = [ "fortify3" ];
  # FIXME: multiple build errors with GCC13.
  # Unlikely to be fixed until we switch to libretro/pcsx2 that is a more
  # up-to-date port (but still WIP).
  stdenv = gcc12Stdenv;

  meta = {
    description = "Port of PCSX2 to libretro";
    homepage = "https://github.com/libretro/lrps2";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.x86;
  };
}
