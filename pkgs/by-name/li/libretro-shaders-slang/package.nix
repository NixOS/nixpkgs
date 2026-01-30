{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2026-01-22";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "a38704e29b8241788d91c64e935862a6e86a2a47";
    hash = "sha256-UBMtUlrbJ+8qh56X1ks19HZCKm1FLmp2bWcNpQJIwdc=";
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
