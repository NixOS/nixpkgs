{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "libretro-core-info";
  version = "1.21.1";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-core-info";
    rev = "v${version}";
    hash = "sha256-k3fVXTDOLOItRq1AC+CU9cCiBH4+T5LAG6NBo3JV2Ys=";
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

  meta = with lib; {
    description = "Libretro's core info files";
    homepage = "https://libretro.com";
    license = licenses.mit;
    teams = [ teams.libretro ];
    platforms = platforms.all;
  };
}
