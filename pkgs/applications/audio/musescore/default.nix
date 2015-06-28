{ stdenv, fetchurl, cmake, pkgconfig
, alsaLib, freetype, libjack2, lame, libogg, libpulseaudio, libsndfile, libvorbis
, portaudio, qt5 #, tesseract
}:

stdenv.mkDerivation rec {
  name = "musescore-${version}";
  version = "2.0.1";

  src = fetchurl {
    url = "https://github.com/musescore/MuseScore/archive/v${version}.tar.gz";
    sha256 = "0n4xk35jggdq2dcizqjq1kdpclih4scpl93ymmxahvfa1vvwn5iw";
  };

  makeFlags = [
    "PREFIX=$(out)"
  ];

  cmakeFlags = [
    "-DAEOLUS=OFF"
    "-DZERBERUS=ON"
    "-DOSC=ON=ON"
    "-DOMR=OFF" # TODO: add OMR support, CLEF_G not declared error
    "-DOCR=OFF" # Not necessary without OMR
    "-DSOUNDFONT3=ON"
    "-DHAS_AUDIOFILE=ON"
    "-DBUILD_JACK=ON"
  ];

  preBuild = ''
    make lupdate
    make lrelease
  '';

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    alsaLib libjack2 freetype lame libogg libpulseaudio libsndfile libvorbis
    portaudio qt5.base qt5.declarative qt5.enginio qt5.script qt5.svg qt5.tools
    qt5.webkit qt5.xmlpatterns #tesseract
  ];

  meta = with stdenv.lib; {
    description = "Music notation and composition software";
    homepage = http://musescore.org/;
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.vandenoever ];
    repositories.git = https://github.com/musescore/MuseScore;
  };
}
