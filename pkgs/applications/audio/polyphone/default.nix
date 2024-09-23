{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  qmake,
  qttools,
  wrapQtAppsHook,
  alsa-lib,
  flac,
  libjack2,
  libogg,
  libvorbis,
  qtsvg,
  qtwayland,
  rtmidi,
}:

stdenv.mkDerivation rec {
  version = "2.4.0";
  pname = "polyphone";

  src = fetchFromGitHub {
    owner = "davy7125";
    repo = "polyphone";
    rev = version;
    hash = "sha256-cPHLmqsS4ReqOCcsgOf77V/ShIkk7chGoJ6bU4W5ejs=";
  };

  nativeBuildInputs = [
    pkg-config
    qmake
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    flac
    libjack2
    libogg
    libvorbis
    qtsvg
    qtwayland
    rtmidi
  ];

  preConfigure = ''
    cd ./sources/
  '';

  postConfigure = ''
    # Work around https://github.com/NixOS/nixpkgs/issues/214765
    substituteInPlace Makefile \
      --replace-fail "$(dirname $QMAKE)/lrelease" "${lib.getBin qttools}/bin/lrelease"
  '';

  qmakeFlags = [
    "DEFINES+=USE_LOCAL_STK"
  ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "Soundfont editor for creating musical instruments";
    mainProgram = "polyphone";
    homepage = "https://www.polyphone-soundfonts.com/";
    license = licenses.gpl3;
    maintainers = with maintainers; [
      maxdamantus
      orivej
    ];
    platforms = platforms.linux;
  };
}
