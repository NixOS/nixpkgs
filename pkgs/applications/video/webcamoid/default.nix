{ lib, fetchFromGitHub, pkg-config, libxcb, mkDerivation, cmake
, qtbase, qtdeclarative, qtquickcontrols, qtquickcontrols2
, ffmpeg_4, gst_all_1, libpulseaudio, alsa-lib, jack2
, v4l-utils }:
mkDerivation rec {
  pname = "webcamoid";
  version = "9.1.1";

  src = fetchFromGitHub {
    sha256 = "sha256-E2hHFrksJtdDLWiX7wL1z9LBbBKT04a853V8u+WiwbA=";
    rev = version;
    repo = "webcamoid";
    owner = "webcamoid";
  };

  buildInputs = [
    libxcb
    qtbase qtdeclarative qtquickcontrols qtquickcontrols2
    ffmpeg_4
    gst_all_1.gstreamer gst_all_1.gst-plugins-base
    alsa-lib libpulseaudio jack2
    v4l-utils
  ];

  nativeBuildInputs = [ pkg-config cmake ];

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
