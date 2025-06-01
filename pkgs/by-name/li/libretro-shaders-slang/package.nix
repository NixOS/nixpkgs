{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-05-20";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "8c630e0d3234d93b6c2bc847371f86aa4e535686";
    hash = "sha256-BDxgVBWDUYgSvEl9dn/PB8c4ceYgM1Bo4aEzvqwTaYA=";
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
