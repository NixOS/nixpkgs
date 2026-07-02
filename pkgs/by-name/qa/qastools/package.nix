{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  alsa-lib,
  udev,
  qt6Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qastools";
  version = "1.4.0";

  src = fetchFromGitLab {
    owner = "sebholt";
    repo = "qastools";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mJjhM1y50f44kvxMidM7uqlkkXx1sbJC21vIMEDenoU=";
  };

  nativeBuildInputs = [
    cmake
    qt6Packages.wrapQtAppsHook
  ];
  buildInputs = [
    alsa-lib
    udev
  ]
  ++ (with qt6Packages; [
    qtbase
    qtsvg
    qttools
  ]);

  meta = {
    description = "Collection of desktop applications for ALSA configuration";
    homepage = "https://gitlab.com/sebholt/qastools";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      avnik
    ];
    platforms = lib.platforms.linux;
  };
})
