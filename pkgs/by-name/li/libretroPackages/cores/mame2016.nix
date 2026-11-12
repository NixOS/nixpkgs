{
  lib,
  alsa-lib,
  fetchFromGitHub,
  mkLibretroCore,
  python3,
  rapidjson,
}:
mkLibretroCore {
  core = "mame2016";
  version = "0-unstable-2026-09-06";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2016-libretro";
    rev = "ae07c2f88ff2482ba9f50ffc8c9e7e6fbfe97d0a";
    hash = "sha256-Jpb7JJ4iPaNO3SuI5xZ83sh28NQShslUl1/+Q2Jd8/Y=";
  };

  postPatch = ''
    rm -r 3rdparty/rapidjson
    ln -s ${lib.getInclude rapidjson} 3rdparty/rapidjson
  '';

  extraNativeBuildInputs = [ python3 ];
  extraBuildInputs = [ alsa-lib ];
  makeFlags = [ "PYTHON_EXECUTABLE=python3" ];

  env = {
    # Build failures when this is set to a bigger number
    NIX_BUILD_CORES = 8;
    # Fix build errors in GCC 13
    NIX_CFLAGS_COMPILE = "-Wno-error -fpermissive";
  };

  meta = {
    description = "Port of MAME ~2016 to libretro, compatible with MAME 0.174 sets";
    homepage = "https://github.com/libretro/mame2016-libretro";
    license = with lib.licenses; [
      bsd3
      gpl2Plus
    ];
  };
}
