{
  lib,
  cmake,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "swanstation";
  version = "0-unstable-2026-10-08";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "swanstation";
    rev = "1db8c9b6866d9d22ee79447762e943a1635d2133";
    hash = "sha256-7ynR2+HzaKgoWyVfn/9ep/wbweANvGujhq269pSNyVo=";
  };

  extraNativeBuildInputs = [ cmake ];
  makefile = "Makefile";
  cmakeFlags = [
    "-DBUILD_LIBRETRO_CORE=ON"
  ];

  meta = {
    description = "Port of SwanStation (a fork of DuckStation) to libretro";
    homepage = "https://github.com/libretro/swanstation";
    license = lib.licenses.gpl3Only;
  };
}
