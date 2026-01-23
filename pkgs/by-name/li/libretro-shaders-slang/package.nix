{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2026-01-11";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "3d62b0e20f5bfa1a244edd70987e565de7e68849";
    hash = "sha256-nkPMdoqIel0OIFM9J99rX50IUKObnEDERpwIkOYGsA4=";
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
