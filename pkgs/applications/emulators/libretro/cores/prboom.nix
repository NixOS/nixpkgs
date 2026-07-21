{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "prboom";
  version = "0-unstable-2026-07-07";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-prboom";
    rev = "31563d6e65faa6b9b7e975754d2062370bba4342";
    hash = "sha256-eFRzbVTL5ARf650D0ZAEFGNTxjAy1CjBiAhwSQR8vJ4=";
  };

  makefile = "Makefile";

  meta = {
    description = "Prboom libretro port";
    homepage = "https://github.com/libretro/libretro-prboom";
    license = lib.licenses.gpl2Only;
  };
}
