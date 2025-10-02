{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-09-26";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "7e3c2ccde32aaa327e109318d275dc16d44653b0";
    hash = "sha256-MkA/pQQhQseoVEOrv/Nfv4gYfx/LmEMN2eFF6McvQnk=";
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
