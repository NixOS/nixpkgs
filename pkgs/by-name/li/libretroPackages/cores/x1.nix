{
  lib,
  fetchFromGitHub,
  mkLibretroCore,
}:
mkLibretroCore {
  core = "x1";
  version = "0-unstable-2026-04-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "xmil-libretro";
    rev = "3e7960a433c3bca820f8b8f5511a2b92bd666829";
    hash = "sha256-a7Od60evOUk+PierbNRUeRXi0LFDhCSuW9izJ0wmzMY=";
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
