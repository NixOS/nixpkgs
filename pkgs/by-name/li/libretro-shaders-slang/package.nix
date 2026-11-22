{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2026-11-04";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "3685eda59ffd2ebe1b12cc4640581dc23552ce88";
    hash = "sha256-C3JIp+6Xsj6cY66W437m2oEodU9uLl9N9QQFuM3TyY8=";
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
