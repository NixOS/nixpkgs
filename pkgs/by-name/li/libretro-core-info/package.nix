{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  gitUpdater,
}:

stdenvNoCC.mkDerivation rec {
  pname = "libretro-core-info";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "libretro-core-info";
    rev = "v${version}";
    hash = "sha256-T/La/Y9txRX8SHAyOi45KcQA8zb3puXdfTKlPSm42+U=";
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
    maintainers = with maintainers; teams.libretro.members ++ [ ];
    platforms = platforms.all;
  };
}
