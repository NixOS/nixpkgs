{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-12-22";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "92ec9ff8c2d53d397b6d943788c748c073ee1fe8";
    hash = "sha256-p2CmXbgd0oKibZa2PiS3xI6KXfsIWtJ+QyvLrc9PFWY=";
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
