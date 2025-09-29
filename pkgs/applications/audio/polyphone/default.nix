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
  version = "2.4.1";
  pname = "polyphone";

  src = fetchFromGitHub {
    owner = "davy7125";
    repo = "polyphone";
    rev = version;
    hash = "sha256-43EswCgNJv11Ov+4vmj2vS/yJ2atyzkRmk/SoCKYD/0=";
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

  meta = {
    broken = (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64);
    description = "Soundfont editor for creating musical instruments";
    mainProgram = "polyphone";
    homepage = "https://www.polyphone-soundfonts.com/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [
      maxdamantus
      orivej
    ];
    platforms = lib.platforms.linux;
  };
}
