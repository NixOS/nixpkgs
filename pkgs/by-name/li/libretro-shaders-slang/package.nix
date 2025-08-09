{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-08-01";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "8fce5bb3cccc532f2a57aff46716cdfc55799e75";
    hash = "sha256-x8Lrq+ECZZzJq9MYHNsJjNPx4Frj/ZzSdN/IM2Tg72g=";
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
