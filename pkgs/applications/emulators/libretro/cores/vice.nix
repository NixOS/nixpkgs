{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2026-07-25";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "d894581b822ad68386505ea9afc64f37c7b71712";
    hash = "sha256-K25D3qN55MJzfKS2twMb5XRwwnisN4hmpcSAIGWLHas=";
  };

  makefile = "Makefile";

  env = {
    EMUTYPE = "${type}";
  };

  meta = {
    description = "Port of vice to libretro";
    homepage = "https://github.com/libretro/vice-libretro";
    license = lib.licenses.gpl2;
  };
}
