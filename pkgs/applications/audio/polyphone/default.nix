{ stdenv, mkDerivation, fetchFromGitHub, qmake, pkgconfig, alsaLib, libjack2, portaudio, libogg, flac, libvorbis, rtmidi, qtsvg }:

mkDerivation rec {
  version = "2.2.0";
  pname = "polyphone";

  src = fetchFromGitHub {
    owner = "davy7125";
    repo = "polyphone";
    rev = version;
    sha256 = "0w5pidzhpwpggjn5la384fvjzkvprvrnidb06068whci11kgpbp7";
  };

  buildInputs = [
    alsaLib
    libjack2
    portaudio
    libogg
    flac
    libvorbis
    rtmidi
    qtsvg
  ];

  nativeBuildInputs = [ qmake pkgconfig ];

  preConfigure = ''
    cd ./sources/
  '';

  installPhase = ''
    install -d $out/bin
    install -m755 bin/polyphone $out/bin/
  '';

  qmakeFlags = [
    "DEFINES+=USE_LOCAL_STK"
    "DEFINES+=USE_LOCAL_QCUSTOMPLOT"
    "INCLUDEPATH+=${libjack2}/include/jack"
  ];

  meta = with stdenv.lib; {
    description = "A soundfont editor for creating musical instruments";
    homepage = "https://www.polyphone-soundfonts.com/";
    license = licenses.gpl3;
    maintainers = [ maintainers.maxdamantus ];
    platforms = platforms.linux;
  };
}
