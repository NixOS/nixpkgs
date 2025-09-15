{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-09-05";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "10b7e86738a8c3eeff7114bcc4ef110d382dd0fd";
    hash = "sha256-Js8RdmP7wjWHK5Z5Yejy53dD04ehgeeH2dY0OjcNIVo=";
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
