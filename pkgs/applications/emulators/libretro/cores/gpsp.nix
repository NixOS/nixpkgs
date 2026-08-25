{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gpsp";
  version = "0-unstable-2026-08-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gpsp";
    rev = "6b12231f03591e60deea389f7a122e594db61388";
    hash = "sha256-fbKK6wsC+G0u6rWwqPsHSAtF9eAeTRn52Z1/aUhmqm8=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of gpSP to libretro";
    homepage = "https://github.com/libretro/gpsp";
    license = lib.licenses.gpl2Only;
  };
}
