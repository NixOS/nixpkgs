{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-02-14";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "130f589cd5a2f3e5df1d6607b82b6771bc8b8446";
    hash = "sha256-ig+cE6MZNeY1Rx6ciSvLuxU0UyLPQLP5c5+lKpq4skA=";
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
