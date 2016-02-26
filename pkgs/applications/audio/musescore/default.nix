{ stdenv, fetchzip, cmake, pkgconfig
, alsaLib, freetype, libjack2, lame, libogg, libpulseaudio, libsndfile, libvorbis
, portaudio, qtbase, qtdeclarative, qtenginio, qtscript, qtsvg, qttools
, qtwebkit, qtxmlpatterns
}:

stdenv.mkDerivation rec {
  name = "musescore-${version}";
  version = "2.0.2";

  src = fetchzip {
    url = "https://github.com/musescore/MuseScore/archive/v${version}.tar.gz";
    sha256 = "12a83v4i830gj76z5744034y1vvwzgy27mjbjp508yh9bd328yqw";
  };

  hardeningDisable = [ "relro" "bindnow" ];

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

  postBuild = ''
    make manpages
  '';

  nativeBuildInputs = [ cmake pkgconfig ];

  enableParallelBuilding = true;

  buildInputs = [
    alsaLib libjack2 freetype lame libogg libpulseaudio libsndfile libvorbis
    portaudio qtbase qtdeclarative qtenginio qtscript qtsvg qttools
    qtwebkit qtxmlpatterns #tesseract
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
