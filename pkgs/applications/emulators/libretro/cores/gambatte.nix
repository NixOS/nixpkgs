{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2026-04-24";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "5ba6bd1ad745e04b7069d0eb2b44091364fc997a";
    hash = "sha256-A9OQx0eXVgrGcmpMTtTe97rHCjrV3Ksi/ooLefsysbQ=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
