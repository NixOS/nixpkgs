{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  which,
}:
mkLibretroCore {
  core = "hatari";
  version = "0-unstable-2026-08-11";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "hatari";
    rev = "24e7bd744f24f20b464385f365a3850c269bd140";
    hash = "sha256-qUhhzbZeqrSsM6xPtohO0wnrcuCMIv0wdLezgpg6/6U=";
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
