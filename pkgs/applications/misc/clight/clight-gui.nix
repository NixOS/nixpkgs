{ lib
, stdenv
, fetchFromGitHub
, cmake
, qtbase
, qtcharts
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "clight-gui";
  version = "unstable-2023-02-21";

  src = fetchFromGitHub {
    owner = "nullobsi";
    repo = "clight-gui";
    rev = "29e7216bfcc68135350a695ce446134bcb0463a6";
    hash = "sha256-U4vaMwnVDZnYLc+K3/yD81Q1vyBL8uSrrhOHbjbox5U=";
  };

  buildInputs = [ qtbase qtcharts ];
  nativeBuildInputs = [ cmake wrapQtAppsHook ];

  sourceRoot = "${src.name}/src";

  meta = with lib; {
    description = "Qt GUI for clight";
    homepage = "https://github.com/nullobsi/clight-gui";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ nickhu ];
    mainProgram = "clight-gui";
    platforms = platforms.linux;
  };
}
