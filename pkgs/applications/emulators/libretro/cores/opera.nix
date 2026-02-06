{
  lib,
  stdenv,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "opera";
  version = "0-unstable-2026-01-27";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "opera-libretro";
    rev = "f20af9ad3271af2de8229f522c6534984a6e2520";
    hash = "sha256-cilOteQK6clVaGdemujrNwfcbI6Gw+UMvtF6hICm3Wo=";
  };

  makefile = "Makefile";
  makeFlags = [ "CC_PREFIX=${stdenv.cc.targetPrefix}" ];

  meta = {
    description = "Opera is a port of 4DO/libfreedo to libretro";
    homepage = "https://github.com/libretro/libretro-o2em";
    license = lib.licenses.unfreeRedistributable;
  };
}
