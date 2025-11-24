{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-11-19";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "279b031c92c7a376be47ffdec5fe669fb5dcebc0";
    hash = "sha256-0OltcN4W0vp7jtDSSIJ2ZanFi5p/efnPDOhaurr3ShY=";
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
