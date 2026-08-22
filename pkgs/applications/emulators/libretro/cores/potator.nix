{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "potator";
  version = "0-unstable-2026-06-04";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "potator";
    rev = "227c5f6f3ce74d32e9002ce24c1420288559a860";
    hash = "sha256-XJMwvzWfgKn594ILO5RHyGA8nxegz+qBI8DHOMSHRWw=";
  };

  makefile = "Makefile";
  preBuild = "cd platform/libretro";

  meta = {
    description = "A Watara Supervision Emulator based on Normmatt version";
    homepage = "https://github.com/libretro/potator";
    license = lib.licenses.unlicense;
  };
}
