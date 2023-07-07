{ lib
, stdenv
, fetchFromGitLab
, fetchpatch
, qtbase
, openrgb
, glib
, openal
, qmake
, pkg-config
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "openrgb-plugin-effects";
  version = "0.8";

  src = fetchFromGitLab {
    owner = "OpenRGBDevelopers";
    repo = "OpenRGBEffectsPlugin";
    rev = "release_${version}";
    hash = "sha256-2F6yeLWgR0wCwIj75+d1Vdk45osqYwRdenK21lcRoOg=";
    fetchSubmodules = true;
  };

  patches = [
    # Add install rule
    (fetchpatch {
      url = "https://gitlab.com/OpenRGBDevelopers/OpenRGBEffectsPlugin/-/commit/75f1b3617d9cabfb3b04a7afc75ce0c1b8514bc0.patch";
      hash = "sha256-X+zMNE3OCZNmUb68S4683r/RbE+CDrI/Jv4BMWPI47E=";
    })
  ];

  postPatch = ''
    # Use the source of openrgb from nixpkgs instead of the submodule
    rm -r OpenRGB
    ln -s ${openrgb.src} OpenRGB
  '';

  nativeBuildInputs = [
    qmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    glib
    openal
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/OpenRGBDevelopers/OpenRGBEffectsPlugin";
    description = "An effects plugin for OpenRGB";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fgaz ];
    platforms = platforms.linux;
  };
}
