{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  which,
}:
mkLibretroCore {
  core = "hatari";
  version = "0-unstable-2026-07-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "hatari";
    rev = "92e2874e664be40e1b51b97e0ff925a1aa917f22";
    hash = "sha256-TwPlz/H0FKHI0wELj5gYTTL2RJIQOwLLIe+UktK3XXI=";
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
