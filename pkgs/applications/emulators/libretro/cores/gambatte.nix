{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2025-09-18";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "0092232a0aaef0ded0ead1c2003ccf7a85ccdfc0";
    hash = "sha256-baiTlYArNSBz79Cm16Sg3VZEp909zMkF/ExqhrPYN80=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
