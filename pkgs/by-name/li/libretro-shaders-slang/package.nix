{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2026-01-08";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "c2f3c5b0ce8c5e7e3ed9d885a924f85712cb38a0";
    hash = "sha256-tQ/eUFNlzKYaP6eDiykCtooccEa2YP++iFXKSUVgwcw=";
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
