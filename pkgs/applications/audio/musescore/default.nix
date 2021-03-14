{ mkDerivation, lib, fetchFromGitHub, cmake, pkg-config
, alsaLib, freetype, libjack2, lame, libogg, libpulseaudio, libsndfile, libvorbis
, portaudio, portmidi, qtbase, qtdeclarative, qtgraphicaleffects
, qtquickcontrols2, qtscript, qtsvg, qttools
, qtwebengine, qtxmlpatterns
, nixosTests
}:

mkDerivation rec {
  pname = "musescore";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "musescore";
    repo = "MuseScore";
    rev = "v${version}";
    sha256 = "sha256-21ZI5rsc05ZWEyM0LeFr+212YViLYveZZBvVpskh8iA=";
  };

  patches = [
    ./remove_qtwebengine_install_hack.patch
  ];

  cmakeFlags = [
    "-DMUSESCORE_BUILD_CONFIG=release"
    "-DUSE_SYSTEM_FREETYPE=ON"
  ];

  qtWrapperArgs = [
    # Work around crash on update from 3.4.2 to 3.5.0
    # https://bugreports.qt.io/browse/QTBUG-85967
    "--set QML_DISABLE_DISK_CACHE 1"
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    alsaLib libjack2 freetype lame libogg libpulseaudio libsndfile libvorbis
    portaudio portmidi # tesseract
    qtbase qtdeclarative qtgraphicaleffects qtquickcontrols2
    qtscript qtsvg qttools qtwebengine qtxmlpatterns
  ];

  passthru.tests = nixosTests.musescore;

  meta = with lib; {
    description = "Music notation and composition software";
    homepage = "https://musescore.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ vandenoever turion ];
    platforms = platforms.linux;
    repositories.git = "https://github.com/musescore/MuseScore";
  };
}
