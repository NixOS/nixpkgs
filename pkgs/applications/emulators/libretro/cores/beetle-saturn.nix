{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-saturn";
  version = "0-unstable-2026-01-12";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-saturn-libretro";
    rev = "b4df47a9f0f30d09eb95b07a4435d0f435a2e95d";
    hash = "sha256-IIjJdw7u/AaqnKCp6LXc4U0GehwrvEukTC54odCFYkU=";
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
