{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "gpsp";
  version = "0-unstable-2025-09-07";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "gpsp";
    rev = "f7a6a4314697ea5e4821a15aa7110795679f6ade";
    hash = "sha256-g63KIeQUvCg9LbixeXF2JRgUEFlzBMctXV8IFqvR0sg=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of gpSP to libretro";
    homepage = "https://github.com/libretro/gpsp";
    license = lib.licenses.gpl2Only;
  };
}
