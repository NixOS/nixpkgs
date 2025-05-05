{
  mkKdeDerivation,
  extra-cmake-modules,
  qtwebchannel,
  qtwebengine,
  qttools,
  python3Packages,
  fetchpatch,
}:
mkKdeDerivation {
  pname = "falkon";

  # Fix crash on startup
  # FIXME: remove in 25.04.1
  patches = [
    (fetchpatch {
      url = "https://invent.kde.org/network/falkon/-/commit/31ba9472369256804400a2db36b3dca3b4be2d73.patch";
      hash = "sha256-jLJjL4Bp03aZfM/OPXZzgL56T0C/2hHSzNERpbTitzw=";
    })
  ];

  extraNativeBuildInputs = [
    qttools
    qtwebchannel
    qtwebengine
  ];

  extraBuildInputs = [
    extra-cmake-modules
    qtwebchannel
    qtwebengine
    python3Packages.pyside6
  ];

  meta.mainProgram = "falkon";
}
