{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2026-08-03";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "620114039b453ebb2e3de1a5846b0d9b05676bf4";
    hash = "sha256-ox5Mo9ShWAVQDT6tboA72Mugny3aCQaN1QLpTs4bR6Y=";
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
