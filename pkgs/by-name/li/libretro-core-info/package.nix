{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "libretro-core-info";
  version = "1.22.2";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-core-info";
    rev = "v${version}";
    hash = "sha256-m3w7czESeKopQtFTJLgAZJwtcXKJAhFhZtZQqQAQXbM=";
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
    teams = [ lib.teams.libretro ];
    platforms = lib.platforms.all;
  };
}
