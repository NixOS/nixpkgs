{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-saturn";
  version = "0-unstable-2026-07-07";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-saturn-libretro";
    rev = "6f0cb9d1b9689601cd7dbf08e992d232304f50f7";
    hash = "sha256-Q50CQDLO090csrF73fo2qxzIaV7o3E8YS9MdQZBp/V8=";
  };

  makefile = "Makefile";

  meta = {
    description = "Port of Mednafen's Saturn core to libretro";
    homepage = "https://github.com/libretro/beetle-saturn-libretro";
    license = lib.licenses.gpl2Only;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
