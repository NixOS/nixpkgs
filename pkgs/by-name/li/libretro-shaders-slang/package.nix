{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "libretro-shaders-slang";
  version = "0-unstable-2025-11-23";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "slang-shaders";
    rev = "2907b8d9e49ec2e2f23ce8ed3a360e77917a8f26";
    hash = "sha256-k41jk5Zh5bsMJzS3CZc8p/6odyTRSLkjuICfo7I7ZTc=";
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
