{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2026-08-14";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "6a7c009273dba8d0607d60ac90634dea11d45343";
    hash = "sha256-tkEl+APyBw6mIlyzaOAsHSEg0xABl0cW/1lkgUocKJQ=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
