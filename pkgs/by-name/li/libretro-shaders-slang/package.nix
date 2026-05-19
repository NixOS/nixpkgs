{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2026-05-07";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "cef2de6123cccbf0393ed6071ffd6e4a8d092145";
    hash = "sha256-DvkWxkIdB9K/UkIk3r7mNT1RhAtEe9sfIX/ffxPiTIE=";
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
