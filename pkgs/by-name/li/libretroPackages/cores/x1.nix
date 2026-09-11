{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "x1";
  version = "0-unstable-2026-08-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "xmil-libretro";
    rev = "3106aa54ffb244cca4019a6e95dacaa698781bc3";
    hash = "sha256-uOb4Fxm2Oo8XD0at0QRAzeYJnAVHfieeWRZ60LH5dnY=";
  };

  sourceRoot = "source";
  makefile = "libretro/Makefile.libretro";

  postPatch = ''
    substituteInPlace libretro/Makefile.libretro \
      --replace-fail 'XMIL_PATH := ..' 'XMIL_PATH := .' \
      --replace-fail 'CORE_DIR := .' 'CORE_DIR := libretro' \
      --replace-fail '--version-script=link.T' '--version-script=libretro/link.T'
  '';

  meta = {
    description = "Sharp X1 emulator core for libretro";
    homepage = "https://github.com/libretro/xmil-libretro";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ kaistarkk ];
  };
}
