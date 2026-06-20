{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2026-06-10";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "140d1bcc67a7287670ad6a02fc77e11c10ef5e07";
    hash = "sha256-EejHojtJDnhgYk5PM8RTiCdV5TCeqcszodHQvs6vVIU=";
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
