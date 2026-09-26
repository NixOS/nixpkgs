{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2026-08-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "9d68d530a92b5666c8dc151a6884aa8ce16df095";
    hash = "sha256-hnBCWIDi6zCOxtL80sr0fIhiDePVmgXO7udgkWp7ej4=";
  };

  dontConfigure = true;
  dontBuild = true;
  installFlags = "PREFIX=${placeholder "out"}";

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Slang shaders for use with RetroArch's shader system";
    homepage = "https://github.com/libretro/slang-shaders";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.nadiaholmquist ];
    platforms = lib.platforms.all;
  };
}
