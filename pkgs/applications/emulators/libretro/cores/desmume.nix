{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
  libpcap,
  libGLU,
  libGL,
  xorg,
}:
mkLibretroCore {
  core = "desmume";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "desmume";
    rev = "7f05a8d447b00acd9e0798aee97b4f72eb505ef9";
    hash = "sha256-BttWMunVbfPOTGx+DV+3QyOwW+55tgXKVIn99DZhbBI=";
  };

  extraBuildInputs = [
    libpcap
    libGLU
    libGL
    xorg.libX11
  ];

  makeFlags =
    lib.optional stdenv.hostPlatform.isAarch32 "platform=armv-unix"
    ++ lib.optional (!stdenv.hostPlatform.isx86) "DESMUME_JIT=0";

  preBuild = "cd desmume/src/frontend/libretro";

  meta = {
    description = "Port of DeSmuME to libretro";
    homepage = "https://github.com/libretro/desmume";
    license = lib.licenses.gpl2Plus;
  };
}
