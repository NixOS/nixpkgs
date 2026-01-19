{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "clight-gui";
  version = "0-unstable-2023-02-21";

  src = fetchFromGitHub {
    owner = "nullobsi";
    repo = "clight-gui";
    rev = "29e7216bfcc68135350a695ce446134bcb0463a6";
    hash = "sha256-U4vaMwnVDZnYLc+K3/yD81Q1vyBL8uSrrhOHbjbox5U=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.0)" \
                     "cmake_minimum_required(VERSION 3.10)"
  '';

  buildInputs = with libsForQt5; [
    qtbase
    qtcharts
  ];
  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];

  sourceRoot = "${finalAttrs.src.name}/src";

  meta = {
    description = "Qt GUI for clight";
    homepage = "https://github.com/nullobsi/clight-gui";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nickhu ];
    mainProgram = "clight-gui";
    platforms = lib.platforms.linux;
  };
})
