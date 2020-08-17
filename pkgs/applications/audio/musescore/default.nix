{ stdenv, mkDerivation, lib, fetchzip, cmake, pkgconfig
, alsaLib, freetype, libjack2, lame, libogg, libpulseaudio, libsndfile, libvorbis
, portaudio, portmidi, qtbase, qtdeclarative, qtgraphicaleffects
, qtquickcontrols2, qtscript, qtsvg, qttools
, qtwebengine, qtxmlpatterns
}:

mkDerivation rec {
  pname = "musescore";
  version = "3.5.0";

  src = fetchzip {
    url = "https://github.com/musescore/MuseScore/releases/download/v3.5/MuseScore-${version}.zip";
    sha256 = "0m598xh0s4f5m4l2ymy7g44bbvc14bcfi4gifhjnrg091rsk57c9";
    stripRoot = false;
  };

  patches = [
    ./remove_qtwebengine_install_hack.patch
  ];

  cmakeFlags = [
    "-DUSE_SYSTEM_FREETYPE=ON"
  ];

  qtWrapperArgs = [
    # Work around crash on update from 3.4.2 to 3.5.0
    # https://bugreports.qt.io/browse/QTBUG-85967
    "--set QML_DISABLE_DISK_CACHE 1"
  ];

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    alsaLib libjack2 freetype lame libogg libpulseaudio libsndfile libvorbis
    portaudio portmidi # tesseract
    qtbase qtdeclarative qtgraphicaleffects qtquickcontrols2
    qtscript qtsvg qttools qtwebengine qtxmlpatterns
  ];

  meta = with stdenv.lib; {
    description = "Music notation and composition software";
    homepage = "https://musescore.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ vandenoever turion ];
    platforms = platforms.linux;
    repositories.git = "https://github.com/musescore/MuseScore";
  };
}
