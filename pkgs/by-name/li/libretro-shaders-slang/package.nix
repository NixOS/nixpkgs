{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-02-27";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "19341d662833b237150b50bc105a4843bd17f53c";
    hash = "sha256-J8Bdqa8d79Jszdjmtaa5xRfe+qZ8gkwRdQS4XFqOwcU=";
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
