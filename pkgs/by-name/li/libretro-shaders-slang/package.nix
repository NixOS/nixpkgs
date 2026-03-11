{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2026-02-27";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "b8a7e9e8eaf1a40210b62e6f967d25d81b37d0c8";
    hash = "sha256-t+M49noCVkYsk2T4yq6tbRgF9XoP8ptcxch9Sq69L88=";
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
