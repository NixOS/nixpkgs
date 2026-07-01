{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2026-06-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "4832d33cc3427ee0a1c1b9065339dd18ff57370d";
    hash = "sha256-qn3zYecSmQjQV1f0Aw6+zVEQttMSHsrNQuMFbsDyKC8=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
