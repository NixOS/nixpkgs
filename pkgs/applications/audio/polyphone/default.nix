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
    runHook preInstall
    install -d $out/bin
    install -m755 bin/polyphone $out/bin/

    install -Dm444 ./contrib/com.polyphone_soundfonts.polyphone.desktop -t $out/share/applications/
    install -Dm444 ./contrib/polyphone.svg -t $out/share/icons/hicolor/scalable/apps/
    runHook postInstall
  '';

  qmakeFlags = [
    "DEFINES+=USE_LOCAL_STK"
    "DEFINES+=USE_LOCAL_QCUSTOMPLOT"
  ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64);
    description = "A soundfont editor for creating musical instruments";
    mainProgram = "polyphone";
    homepage = "https://www.polyphone-soundfonts.com/";
    license = licenses.gpl3;
    maintainers = [ maintainers.maxdamantus ];
    platforms = platforms.linux;
  };
}
