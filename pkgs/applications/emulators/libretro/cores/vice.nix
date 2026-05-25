{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2026-05-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "b0d88812a0af0dcba40041d78709480ad1d90833";
    hash = "sha256-OD1OB68g8WxpXLyJ0YIQ9Ys6D4eoARFjjFx+gAdeYGg=";
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
