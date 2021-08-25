{ lib, fetchFromGitHub, pkg-config, libxcb, mkDerivation, qmake
, qtbase, qtdeclarative, qtquickcontrols, qtquickcontrols2
, ffmpeg-full, gst_all_1, libpulseaudio, alsa-lib, jack2
, v4l-utils }:
mkDerivation rec {
  pname = "webcamoid";
  version = "8.8.0";

  src = fetchFromGitHub {
    sha256 = "0a8M9GQ6Ea9jBCyfbORVyB6HC/O6jdcIZruQZj9Aai4=";
    rev = version;
    repo = "webcamoid";
    owner = "webcamoid";
  };

  buildInputs = [
    libxcb
    qtbase qtdeclarative qtquickcontrols qtquickcontrols2
    ffmpeg-full
    gst_all_1.gstreamer gst_all_1.gst-plugins-base
    alsa-lib libpulseaudio jack2
    v4l-utils
  ];

  nativeBuildInputs = [ pkg-config qmake ];

  qmakeFlags = [
    "Webcamoid.pro"
    "INSTALLQMLDIR=${placeholder "out"}/lib/qt/qml"
  ];

  meta = with lib; {
    description = "Webcam Capture Software";
    longDescription = "Webcamoid is a full featured and multiplatform webcam suite.";
    homepage = "https://github.com/webcamoid/webcamoid/";
    license = [ licenses.gpl3Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ robaca ];
  };
}
