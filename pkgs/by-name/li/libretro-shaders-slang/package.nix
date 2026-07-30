{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2026-07-15";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "3b0d6aa1d134a168478cd9c904a866d969f8882b";
    hash = "sha256-wSrKcrX5GcTXfaxxjyd7COAFsaZsed8pYtScqGo+LA8=";
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
