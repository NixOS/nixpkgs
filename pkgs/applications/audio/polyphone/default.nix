{ stdenv, lib, mkDerivation, fetchFromGitHub, qmake, pkg-config, alsa-lib, libjack2, portaudio, libogg, flac, libvorbis, rtmidi, qtsvg, qttools }:

mkDerivation rec {
  version = "2.3.0";
  pname = "polyphone";

  src = fetchFromGitHub {
    owner = "davy7125";
    repo = "polyphone";
    rev = version;
    sha256 = "09habv51pw71wrb39shqi80i2w39dx5a39klzswsald5j9sia0ir";
  };

  buildInputs = [
    alsa-lib
    libjack2
    portaudio
    libogg
    flac
    libvorbis
    rtmidi
    qtsvg
  ];

  nativeBuildInputs = [ qmake qttools pkg-config ];

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

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "A soundfont editor for creating musical instruments";
    homepage = "https://www.polyphone-soundfonts.com/";
    license = licenses.gpl3;
    maintainers = [ maintainers.maxdamantus ];
    platforms = platforms.linux;
  };
}
