{
  lib,
  alsa-lib,
  fetchFromGitHub,
  mkLibretroCore,
  python3,
}:
mkLibretroCore {
  core = "mame2016";
  version = "0-unstable-2024-04-06";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "mame2016-libretro";
    rev = "01058613a0109424c4e7211e49ed83ac950d3993";
    hash = "sha256-IsM7f/zlzvomVOYlinJVqZllUhDfy4NNTeTPtNmdVak=";
  };

  patches = [ ./patches/mame2016-python311.patch ];
  extraNativeBuildInputs = [ python3 ];
  extraBuildInputs = [ alsa-lib ];
  makeFlags = [ "PYTHON_EXECUTABLE=python3" ];
  # Build failures when this is set to a bigger number
  NIX_BUILD_CORES = 8;
  # Fix build errors in GCC13
  NIX_CFLAGS_COMPILE = "-Wno-error -fpermissive";

  meta = {
    description = "Port of MAME ~2016 to libretro, compatible with MAME 0.174 sets";
    homepage = "https://github.com/libretro/mame2016-libretro";
    license = with lib.licenses; [
      bsd3
      gpl2Plus
    ];
  };
}
