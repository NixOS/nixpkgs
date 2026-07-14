{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "fceumm";
  version = "0-unstable-2026-07-06";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-fceumm";
    rev = "0d610d9a6401697157f693a5407adf450a0e52fb";
    hash = "sha256-4QroyuhQrH5FhK86nuUztvrIwG4Ibj2zltPhhdLuJm0=";
  };

  meta = {
    description = "FCEUmm libretro port";
    homepage = "https://github.com/libretro/libretro-fceumm";
    license = lib.licenses.gpl2Only;
  };
}
