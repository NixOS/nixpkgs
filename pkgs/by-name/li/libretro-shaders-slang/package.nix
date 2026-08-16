{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2026-08-08";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "a7f04a0698908015c6f9e3a3f446b3d17083269c";
    hash = "sha256-Zz5EqEyGZwMZcFgowUpW2b3/cRcmOHL5R/Z78sg4dm8=";
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
