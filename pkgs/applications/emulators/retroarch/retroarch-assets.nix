{ lib
, stdenvNoCC
, fetchFromGitHub
, unstableGitUpdater
}:

stdenvNoCC.mkDerivation {
  pname = "retroarch-assets";
  version = "1.19.0-unstable-2024-08-08";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "retroarch-assets";
    rev = "8a74442fabfc6f72c623dbf1f7a59bfeba771b9f";
    hash = "sha256-rlIxKciCZK0UDAHsnEcUpFlKT0Y7vd1WqN8UfUOn7cA=";
  };

  makeFlags = [
    "PREFIX=$(out)"
    # By default install in $(PREFIX)/share/libretro/assets
    # that is not in RetroArch's assets path
    "INSTALLDIR=$(PREFIX)/share/retroarch/assets"
  ];

  dontBuild = true;

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = with lib; {
    description = "Assets needed for RetroArch";
    homepage = "https://libretro.com";
    license = licenses.mit;
    maintainers = with maintainers; teams.libretro.members ++ [ ];
    platforms = platforms.all;
  };
}
