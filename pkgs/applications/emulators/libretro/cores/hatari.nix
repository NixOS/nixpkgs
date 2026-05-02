{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  which,
}:
mkLibretroCore {
  core = "hatari";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "hatari";
    rev = "6aa7c7079b3186025ebc6bad4b4251aa359a3947";
    hash = "sha256-17L2EpLGwkWA/9XTgtIq+PNABGvgdBQDsAfAZFRKLOE=";
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
