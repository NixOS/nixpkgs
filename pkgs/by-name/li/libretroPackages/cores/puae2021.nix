{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "puae2021";
  version = "0-unstable-2025-11-02";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-uae";
    rev = "58527ce9e8cc5f19faae9e6010d2f06fc70b10de";
    hash = "sha256-wHzjpTh/zuV5KXaMsv7A/7xqYfzLgIUusjwg8LOUzMY=";
  };

  makefile = "Makefile";

  meta = {
    description = "Amiga emulator based on WinUAE (Version 2021)";
    homepage = "https://github.com/libretro/libretro-uae";
    license = lib.licenses.gpl2Only;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
