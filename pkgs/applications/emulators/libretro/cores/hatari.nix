{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  which,
}:
mkLibretroCore {
  core = "hatari";
  version = "0-unstable-2026-03-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "hatari";
    rev = "00af13a379e7839399ff2939807f050b7fc49a0e";
    hash = "sha256-mPe9+RX9DsrJkmydXqEBrR7EMwijhjj/yJPB2QlK3/U=";
  };

  extraNativeBuildInputs = [ which ];
  dontConfigure = true;
  # zlib is already included in mkLibretroCore as buildInputs
  makeFlags = [ "EXTERNAL_ZLIB=1" ];

  meta = {
    description = "Port of Hatari to libretro";
    homepage = "https://github.com/libretro/hatari";
    license = lib.licenses.gpl2Only;
  };
}
