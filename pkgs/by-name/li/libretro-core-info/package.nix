{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "libretro-core-info";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-core-info";
    rev = "v${version}";
    hash = "sha256-dMMX9i2xPKay6BKC52fYxElcGSllHkSZyOXX/t3l6Io=";
  };

  makeFlags = [
    "PREFIX=$(out)"
    # By default install in $(PREFIX)/share/libretro/info
    # that is not in RetroArch's core info path
    "INSTALLDIR=$(PREFIX)/share/retroarch/cores"
  ];

  dontBuild = true;

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };

  meta = {
    description = "Libretro's core info files";
    homepage = "https://libretro.com";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; lib.teams.libretro.members ++ [ ];
    platforms = lib.platforms.all;
  };
}
