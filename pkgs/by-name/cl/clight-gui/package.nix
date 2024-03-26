{ lib
, stdenv
, fetchFromGitHub
, cmake
, libsForQt5
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clight-gui";
  version = "unstable-2023-02-21";

  src = fetchFromGitHub {
    owner = "nullobsi";
    repo = "clight-gui";
    rev = "29e7216bfcc68135350a695ce446134bcb0463a6";
    hash = "sha256-U4vaMwnVDZnYLc+K3/yD81Q1vyBL8uSrrhOHbjbox5U=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtcharts
  ];

  meta = with lib; {
    description = "Qt GUI for clight";
    homepage = "https://github.com/nullobsi/clight-gui";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ fgaz ];
    mainProgram = "clight-gui";
    platforms = platforms.all;
  };
})
