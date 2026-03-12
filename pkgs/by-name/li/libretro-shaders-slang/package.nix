{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2026-02-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "ff3bd235e1c59e73da2b878aa12dfce8b79f3dbf";
    hash = "sha256-yIIUPDzHit4K/5guZ3lNY5NJhcqZx/z8P9XG+HP5sLs=";
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
