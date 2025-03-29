{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:

stdenvNoCC.mkDerivation {
  pname = "retroarch-assets";
  version = "1.20.0-unstable-2025-03-21";

  src = fetchFromGitHub {
    owner = "libretro";
    repo = "retroarch-assets";
    rev = "818aca56efd784624a241a12936b5c0864e3ddd8";
    hash = "sha256-14n9oQbvzl66pgWLMYEpAM7uJUH5e8a3xRCy5f1TFIw=";
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
