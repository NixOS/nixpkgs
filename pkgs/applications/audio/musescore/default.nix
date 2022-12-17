{ stdenv, lib, fetchFromGitHub, cmake, pkg-config
, libjack2, libpulseaudio
, libvorbis, libogg
, libsndfile, alsa-lib, openssl_1_1, lame
, qtdeclarative, qtgraphicaleffects, qtscript, qtsvg, qtwebengine
, qtnetworkauth, qtquickcontrols2, qtxmlpatterns, qttools, qtx11extras
, wrapQtAppsHook, autoPatchelfHook
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "musescore";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "musescore";
    repo = "MuseScore";
    rev = "v${version}";
    hash = "sha256-mc3FYLrzEyUHNFH/P57dWKKHl2Lxew1AQBu+70zmLJs=";
  };

  nativeBuildInputs = [
    cmake pkg-config
    wrapQtAppsHook
    autoPatchelfHook
  ];

  cmakeFlags = [
    "-DMUSESCORE_BUILD_CONFIG=release"
  ];

  buildInputs = [
    libjack2 libpulseaudio libvorbis libogg
    lame libsndfile alsa-lib openssl_1_1
    qtnetworkauth qtquickcontrols2 qtxmlpatterns qttools
    qtx11extras qtdeclarative qtgraphicaleffects qtscript
    qtsvg qtwebengine
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
