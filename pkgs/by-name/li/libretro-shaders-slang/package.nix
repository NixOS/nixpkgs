{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2026-05-05";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "2ba50bfaeae630741216a9b60b5147485657316f";
    hash = "sha256-3hJ/rpTDI8oqd4t/dTAHztmWkXW769cAqbmt5jVdIHE=";
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
