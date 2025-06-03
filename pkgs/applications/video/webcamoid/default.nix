{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  libxcb,
  cmake,
  qtbase,
  qtdeclarative,
  wrapQtAppsHook,
  qtsvg,
  ffmpeg,
  gst_all_1,
  libpulseaudio,
  alsa-lib,
  jack2,
  v4l-utils,
}:

stdenv.mkDerivation rec {
  pname = "webcamoid";
  version = "9.2.3";

  src = fetchFromGitHub {
    owner = "webcamoid";
    repo = "webcamoid";
    tag = version;
    hash = "sha256-j4FiRQeFsrZD48P1CUESFytz9l/64Lz1EuOZp0ZSEmI=";
  };

  buildInputs = [
    libxcb
    qtbase
    qtdeclarative
    qtsvg
    ffmpeg
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    alsa-lib
    libpulseaudio
    jack2
    v4l-utils
  ];

  nativeBuildInputs = [
    pkg-config
    cmake
    wrapQtAppsHook
  ];

  meta = {
    description = "Webcam Capture Software";
    longDescription = "Webcamoid is a full featured and multiplatform webcam suite.";
    homepage = "https://github.com/webcamoid/webcamoid/";
    license = with lib.licenses; [ gpl3Plus ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ robaca ];
    mainProgram = "webcamoid";
  };
}
