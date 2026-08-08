{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "mednafen-saturn";
  version = "0-unstable-2026-07-30";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "beetle-saturn-libretro";
    rev = "5231aa238ff2bf61b1ed88775711b71692c8e37c";
    hash = "sha256-vVAnNXTyHpVImkwtCc8h0l/thxre08M7jyzZWk81pVY=";
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
