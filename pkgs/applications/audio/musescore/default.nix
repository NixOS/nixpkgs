{ stdenv, mkDerivation, lib, fetchzip, cmake, pkgconfig
, alsaLib, freetype, libjack2, lame, libogg, libpulseaudio, libsndfile, libvorbis
, portaudio, portmidi, qtbase, qtdeclarative, qtscript, qtsvg, qttools
, qtwebengine, qtxmlpatterns
}:

mkDerivation rec {
  pname = "musescore";
  version = "3.0.5";

  src = fetchzip {
    url = "https://download.musescore.com/releases/MuseScore-${version}/MuseScore-${version}.zip";
    sha256 = "1pbf6v0l3nixxr8k5igwhj09wnqvw92av6q6yjrbb3kyjh5br2d8";
    stripRoot = false;
  };

  patches = [
    ./remove_qtwebengine_install_hack.patch
  ];

  cmakeFlags = [
  ] ++ lib.optional (lib.versionAtLeast freetype.version "2.5.2") "-DUSE_SYSTEM_FREETYPE=ON";

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    alsaLib libjack2 freetype lame libogg libpulseaudio libsndfile libvorbis
    portaudio portmidi # tesseract
    qtbase qtdeclarative qtscript qtsvg qttools qtwebengine qtxmlpatterns
  ];

  meta = with stdenv.lib; {
    description = "Music notation and composition software";
    homepage = https://musescore.org/;
    license = licenses.gpl2;
    maintainers = with maintainers; [ vandenoever ];
    platforms = platforms.linux;
    repositories.git = https://github.com/musescore/MuseScore;
  };
}
