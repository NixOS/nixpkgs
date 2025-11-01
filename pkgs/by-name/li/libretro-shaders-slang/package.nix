{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-10-30";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "bb15fc268529cad6132f288f90e87c07c37212e3";
    hash = "sha256-EVthZs6zrqJYWpTPae8ZNxY9J69YauVxr45MQ0OXQc4=";
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
