{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-11-13";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "7b0fb588c7cf00ff64703a5ffacebd5f491f40db";
    hash = "sha256-Eh7K3xm1WBSsHbP1FK5qxJYIcsmCwDe9PpKJ//j26TU=";
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
