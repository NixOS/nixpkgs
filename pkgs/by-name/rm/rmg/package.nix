{ lib
, stdenv
, fetchFromGitHub

, cmake
, nasm
, ninja
, pkg-config
, which

, hidapi
, libsamplerate
, minizip
, qt6
, SDL2
, speexdsp
}:

stdenv.mkDerivation rec {
  pname = "rmg";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "Rosalie241";
    repo = "RMG";
    rev = "v${version}";
    hash = "sha256-SAQJKfYoouJ2DLVks6oXiyiOI2/kgmyaHqt/FRfqKjI=";
  };

  nativeBuildInputs = [
    cmake
    nasm
    ninja
    pkg-config
    qt6.wrapQtAppsHook
    which
  ];

  buildInputs = [
    hidapi
    libsamplerate
    minizip
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
    SDL2
    speexdsp
  ];

  cmakeFlags = [
    "-DNO_RUST=ON"
    "-DPORTABLE_INSTALL=OFF"
  ];

  meta = with lib; {
    description = "Rosalie's Mupen GUI";
    homepage = "https://github.com/Rosalie241/RMG";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    mainProgram = "RMG";
    maintainers = with maintainers; [ paveloom ];
  };
}
