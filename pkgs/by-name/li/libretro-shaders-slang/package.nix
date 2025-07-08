{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-07-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "5c2c28f79716968381f71b3470ee0064762d7c6f";
    hash = "sha256-L+jTTZA2qg/PlZtI0G0rzLk5is6cUFiTfy2RTcry5vA=";
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
