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
  core = "desmume2015";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "desmume2015";
    rev = "af397ff3d1f208c27f3922cc8f2b8e08884ba893";
    hash = "sha256-kEb+og4g7rJvCinBZKcb42geZO6W8ynGsTG9yqYgI+U=";
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

  preBuild = "cd desmume";

  meta = {
    description = "Port of DeSmuME ~2015 to libretro";
    homepage = "https://github.com/libretro/desmume2015";
    license = lib.licenses.gpl2Plus;
  };
}
