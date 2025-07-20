{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-07-13";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "82d91f7daf81a41ece49644d2a26b2a40228be61";
    hash = "sha256-zRtn+Fc1sw3Uja5vJ5/1IRPr/xG5O0wIKflHr96tu3I=";
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
