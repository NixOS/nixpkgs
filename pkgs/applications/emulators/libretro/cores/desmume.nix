{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
  libpcap,
  libGLU,
  libGL,
  libx11,
}:
mkLibretroCore {
  core = "desmume";
  version = "0-unstable-2026-05-16";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "desmume";
    rev = "ae0f7f51f96d9b5741b47b425505a4a4224b91fa";
    hash = "sha256-M8Z2Zk9wjEuOOg++Tk68A8hgCmE63nh9+oJhu4fsQsk=";
  };

  extraBuildInputs = [
    libpcap
    libGLU
    libGL
    libx11
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
