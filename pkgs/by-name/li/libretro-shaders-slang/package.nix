{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2026-06-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "8ec4c82cf61a6ce3faae1e6111457d0d31920b60";
    hash = "sha256-nPmDmuaa64I0QMHoUTr1nD6g3STyx0+cW3tY/q26M4A=";
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
