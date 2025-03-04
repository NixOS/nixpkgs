{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "serial-studio";
  version = "3.0.6";

  src = fetchFromGitHub {
    owner = "Serial-Studio";
    repo = "Serial-Studio";
    rev = "v${version}";
    hash = "sha256-q3RWy3HRs5NG0skFb7PSv8jK5pI5rtbccP8j38l8kjM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qtgraphs
    qt6.qtlocation
    qt6.qtconnectivity
    qt6.qttools
    qt6.qtserialport
    qt6.qtpositioning
  ];

  patches = [
    ./0001-CMake-Deploy-Fix.patch
    ./0002-Connect-Button-Fix.patch
  ];

  meta = with lib; {
    description = "Multi-purpose serial data visualization & processing program";
    mainProgram = "serial-studio";
    homepage = "https://serial-studio.github.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.linux;
  };
}
