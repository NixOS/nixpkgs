{
  lib,
  fetchFromGitHub,
  fetchpatch2,
  pkg-config,
  libxcb,
  mkDerivation,
  cmake,
  qtbase,
  qtdeclarative,
  qtquickcontrols,
  qtquickcontrols2,
  ffmpeg,
  gst_all_1,
  libpulseaudio,
  alsa-lib,
  jack2,
  v4l-utils,
}:
mkDerivation rec {
  pname = "webcamoid";
  version = "9.1.1";

  src = fetchFromGitHub {
    sha256 = "sha256-E2hHFrksJtdDLWiX7wL1z9LBbBKT04a853V8u+WiwbA=";
    rev = version;
    repo = "webcamoid";
    owner = "webcamoid";
  };

  patches = [
    # Update mediawriterffmpeg.cpp for ffmpeg-7.0
    (fetchpatch2 {
      url = "https://github.com/webcamoid/webcamoid/commit/b4864f13ec8c2ec93ebb5c13d9293cf9c02c93fd.patch?full_index=1";
      hash = "sha256-QasfVocxAzRMME03JFRfz7QQYXQGq4TSFiBsKL1g/wU=";
    })
  ];

  buildInputs = [
    libxcb
    qtbase
    qtdeclarative
    qtquickcontrols
    qtquickcontrols2
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
  ];

  meta = with lib; {
    description = "Webcam Capture Software";
    longDescription = "Webcamoid is a full featured and multiplatform webcam suite.";
    homepage = "https://github.com/webcamoid/webcamoid/";
    license = [ licenses.gpl3Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ robaca ];
    mainProgram = "webcamoid";
  };
}
