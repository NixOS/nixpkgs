{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-05-04";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "2668d46e9e79e5c364fd4dfbece7fc92eda358dd";
    hash = "sha256-j92MH50k7eD6Zwp76aWoz3xdUMFrcviijGigr+NZRsA=";
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
