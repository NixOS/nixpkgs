{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2026-01-02";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "bb2899e53c3d785efceae56be38503d1bcbe6359";
    hash = "sha256-Ed3E4pMtw90iYwNVN/QOA7ICL1yAkGRPQOCGei2+BIQ=";
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
