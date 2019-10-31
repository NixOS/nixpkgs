{ stdenv, mkDerivation, lib, fetchzip, cmake, pkgconfig
, alsaLib, freetype, libjack2, lame, libogg, libpulseaudio, libsndfile, libvorbis
, portaudio, portmidi, qtbase, qtdeclarative, qtscript, qtsvg, qttools
, qtwebengine, qtxmlpatterns
}:

mkDerivation rec {
  pname = "musescore";
  version = "3.2.3";

  src = fetchzip {
    url = "https://github.com/musescore/MuseScore/releases/download/v${version}/MuseScore-${version}.zip";
    sha256 = "17mr0c8whw6vz86lp1j36rams4h8virc4z68fld0q3rpq6g05szs";
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
