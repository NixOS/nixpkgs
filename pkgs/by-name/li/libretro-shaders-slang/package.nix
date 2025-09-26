{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-09-14";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "39ca959b131e75dcd0cb4016e545b4e91b7081ae";
    hash = "sha256-8G54UuuuZpi/sqEWfK/XNXEjjL9LGmffNAnQ+g/XQPM=";
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
