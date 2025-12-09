{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-12-02";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "cf5c768ffda2520d4938df68d33fd63fff276c0c";
    hash = "sha256-0ExGupoxdKAbQ6znzHixivvskFwgO+aKLsRvJlfB0Oc=";
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
