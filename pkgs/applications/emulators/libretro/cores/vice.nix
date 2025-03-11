{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
  type ? "x64",
}:
mkLibretroCore {
  core = "vice-${type}";
  version = "0-unstable-2025-02-07";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "vice-libretro";
    rev = "67b18766e5911ed413ee999aefebc224adb6956a";
    hash = "sha256-ijQ/JnjjlCwVuwTtjU45iEKsmi9LOIEainizPduC27U=";
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
