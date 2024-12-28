{
  lib,
  alsa-lib,
  fetchFromGitHub,
  fetchpatch2,
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

  patches = [
    ./patches/mame2016-python311.patch
    (fetchpatch2 {
      # fix build on GCC 14
      url = "https://github.com/Tencent/rapidjson/commit/9bd618f545ab647e2c3bcbf2f1d87423d6edf800.patch?full_index=1";
      hash = "sha256-NIhoEaNwlo208g9pLZOSJnW6V5wFEhPN3JskQTsrjTI=";
      stripLen = "1";
      extraPrefix = "3rdparty/rapidjson/";
    })
  ];

  extraNativeBuildInputs = [ python3 ];
  extraBuildInputs = [ alsa-lib ];
  makeFlags = [ "PYTHON_EXECUTABLE=python3" ];
  # Build failures when this is set to a bigger number
  NIX_BUILD_CORES = 8;
  # Fix build errors in GCC13, GCC14
  NIX_CFLAGS_COMPILE = "-Wno-error -Wno-error=implicit-function-declaration -fpermissive";

  meta = {
    description = "Port of MAME ~2016 to libretro, compatible with MAME 0.174 sets";
    homepage = "https://github.com/libretro/mame2016-libretro";
    license = with lib.licenses; [
      bsd3
      gpl2Plus
    ];
  };
}
