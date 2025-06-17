{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-05-31";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "3f15f4930a1dd80117d00bab1ed95d7a7ba62b4b";
    hash = "sha256-yhnblVSV6HZ0ZnfD5glZ6y7+SOio17+l5bVs0+vaY7w=";
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
