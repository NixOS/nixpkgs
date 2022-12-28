{ mkDerivation, lib, fetchFromGitHub, cmake, pkg-config
, alsa-lib, freetype, libjack2, lame, libogg, libpulseaudio, libsndfile, libvorbis
, portaudio, portmidi, qtbase, qtdeclarative, qtgraphicaleffects
, qtquickcontrols2, qtscript, qtsvg, qttools
, qtwebengine, qtxmlpatterns
, nixosTests
}:

mkDerivation rec {
  pname = "musescore";
  version = "3.6.2";

  src = fetchFromGitHub {
    owner = "musescore";
    repo = "MuseScore";
    rev = "v${version}";
    sha256 = "sha256-GBGAD/qdOhoNfDzI+O0EiKgeb86GFJxpci35T6tZ+2s=";
  };

  patches = [
    ./remove_qtwebengine_install_hack.patch
  ];

  cmakeFlags = [
    "-DMUSESCORE_BUILD_CONFIG=release"
    "-DUSE_SYSTEM_FREETYPE=ON"
  ];

  qtWrapperArgs = [
    # MuseScore JACK backend loads libjack at runtime.
    "--prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libjack2 ]}"
    # There are some issues with using the wayland backend, see:
    # https://musescore.org/en/node/321936
    "--set-default QT_QPA_PLATFORM xcb"
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    alsa-lib libjack2 freetype lame libogg libpulseaudio libsndfile libvorbis
    portaudio portmidi # tesseract
    qtbase qtdeclarative qtgraphicaleffects qtquickcontrols2
    qtscript qtsvg qttools qtwebengine qtxmlpatterns
  ];

  passthru.tests = nixosTests.musescore;

  meta = with lib; {
    description = "Music notation and composition software";
    homepage = "https://musescore.org/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ vandenoever turion doronbehar ];
    platforms = platforms.linux;
  };
}
