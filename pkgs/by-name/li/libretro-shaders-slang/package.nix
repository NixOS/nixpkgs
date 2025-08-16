{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-08-07";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "a2ccf619c2df565ac8f3e66c91170faa5ba06aa4";
    hash = "sha256-0OjqfYgxJGtFCuPFqlSorqOEOqCf0gdyDUzG15Z/FlA=";
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
