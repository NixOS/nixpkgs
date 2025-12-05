{
  stdenv,
  lib,
  fetchFromGitLab,
  cmake,
  alsa-lib,
  udev,
  qt6Packages,
}:

stdenv.mkDerivation rec {
  pname = "qastools";
  version = "1.4.0";

  src = fetchFromGitLab {
    owner = "sebholt";
    repo = "qastools";
    rev = "v${version}";
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

  meta = with lib; {
    description = "Collection of desktop applications for ALSA configuration";
    homepage = "https://gitlab.com/sebholt/qastools";
    license = licenses.mit;
    maintainers = with maintainers; [
      avnik
    ];
    platforms = platforms.linux;
  };
}
