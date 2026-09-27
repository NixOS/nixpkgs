{
  lib,
  stdenv,
  fetchFromGitHub,
  qt5,
  pkg-config,
  ffmpeg,
  gst_all_1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "QOpenHD";
  version = "2.6.0-unstable-2025-09-09";
  gitRev = "821d6b9cfa7198e2ce582af10e4365685a8bb510";

  src = fetchFromGitHub {
    owner = "OpenHD";
    repo = "QOpenHD";
    rev = finalAttrs.gitRev;
    hash = "sha256-IWg2S1Kl+FoUQ53sO24s7q9NfYMlEF/gnca2OAMhKpg=";
  };

  nativeBuildInputs = [
    qt5.qmake
    qt5.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    ffmpeg
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    qt5.qtcharts
    qt5.qtmultimedia
    qt5.qtquickcontrols2
    qt5.qtspeech
  ];

  mavlinkHeadersSrc = fetchFromGitHub {
    owner = "OpenHD";
    repo = "mavlink-headers";
    rev = "a34e186e2ec6c6a2add840254691a6719606e189";
    hash = "sha256-s4hIsLhXIaitIwQE6tgJEtHVYeqpP5LnuNNxVrrIJfY=";
  };

  postPatch = ''
    echo "Injecting mavlink-headers source to the expected location ..."
    # Doesn't like this to be a symlink
    mkdir -p lib/mavlink-headers
    cp -r ${finalAttrs.mavlinkHeadersSrc}/* lib/mavlink-headers/

    substituteInPlace git.pri \
      --replace-fail \
        'QOPENHD_GIT_VERSION = $$system(git describe --always --tags --abbrev=0 --dirty)' \
        'QOPENHD_GIT_VERSION = "${finalAttrs.version}"'

    substituteInPlace git.pri \
      --replace-fail \
        'QOPENHD_GIT_COMMIT_HASH = $$system(git rev-parse HEAD)' \
        'QOPENHD_GIT_COMMIT_HASH = "${finalAttrs.gitRev}"'
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    ls -lisa release/
    cp release/QOpenHD $out/bin/
    runHook postInstall
  '';

  meta = {
    mainProgram = "QOpenHD";
    longDescription = ''
      QOpenHD is the default OpenHD companion app that runs on the OHD Ground station
      or any other "external" devices connected to the ground station.
    '';
    homepage = "https://openhdfpv.org/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ marijanp ];
    platforms = lib.platforms.linux;
  };
})
