{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "retroarch-assets";
  version = "1.19.0-unstable-2024-09-22";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "retroarch-assets";
    rev = "1b138de1023272b039273d7bbc8f57573073bd25";
    hash = "sha256-ZePPjNQtzO3e7d9ZqbkfXX+0saus2X77It2l1e7WDWc=";
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
