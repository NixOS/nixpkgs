{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-10-15";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "c94b1bdfd8c973893ac3fe883ae05c420aba2908";
    hash = "sha256-aZ6Xf7suIlUj3NcGtRfoYTKMnenCupS7dLoENGePr/E=";
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
