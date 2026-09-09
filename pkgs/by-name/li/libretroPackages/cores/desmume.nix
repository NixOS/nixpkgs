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
  version = "0-unstable-2026-08-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "desmume";
    rev = "8f6b32cb9a5e310bd38520e7087ce7fa14765f15";
    hash = "sha256-u1YTW7thPzmcse0XDs7WOu3foL7kf+urplOufQqawW8=";
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
