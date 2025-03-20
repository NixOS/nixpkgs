{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-03-13";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "25311dc03332d9ef2dff8d9d06c611d828028fac";
    hash = "sha256-nmDjjQgxpZcddOHlBAE9CKdR95u+6lEYXcmIwH9RHXo=";
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
