{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-saturn";
  version = "0-unstable-2026-08-11";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-saturn-libretro";
    rev = "ed549bdac0e1a830bb794fa720e45c225a45355c";
    hash = "sha256-uRmkeRuOM2JN5OvuImAxyRyRPjXxCHeAl828304hF0o=";
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
