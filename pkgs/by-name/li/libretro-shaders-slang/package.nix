{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-06-24";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "1ed1b59acec51a3156ec70522fb98be3c74f95f4";
    hash = "sha256-G0LQCatfiYPwOfB/fE2PvVUDyAkgoYtHkTix0XU5oE8=";
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
