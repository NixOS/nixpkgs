{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gambatte";
  version = "0-unstable-2026-04-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gambatte-libretro";
    rev = "483a1f13f7e8a1c2b3076eb8bfc38e668e640c17";
    hash = "sha256-efpehssNF3FmSbJAqRS1PkYWTs1v0y0KTdBiRV8K/WY=";
  };

  meta = {
    description = "Gambatte libretro port";
    homepage = "https://github.com/libretro/gambatte-libretro";
    license = lib.licenses.gpl2Only;
  };
}
