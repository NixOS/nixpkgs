{ stdenv, fetchFromGitHub, pkgconfig, libxcb, mkDerivation, qmake
, qtbase, qtdeclarative, qtquickcontrols, qtquickcontrols2
, ffmpeg-full, gstreamer, gst_all_1, libpulseaudio, alsaLib, jack2
, v4l-utils }:
mkDerivation rec {
  pname = "webcamoid";
  version = "8.7.1";

  src = fetchFromGitHub {
    sha256 = "1d8g7mq0wf0ycds87xpdhr3zkljgjmb94n3ak9kkxj2fqp9242d2";
    rev = version;
    repo = "webcamoid";
    owner = "webcamoid";
  };

  buildInputs = [
    libxcb
    qtbase qtdeclarative qtquickcontrols qtquickcontrols2
    ffmpeg-full
    gstreamer gst_all_1.gst-plugins-base
    alsaLib libpulseaudio jack2
    v4l-utils
  ];

  nativeBuildInputs = [ pkgconfig qmake ];

  qmakeFlags = [
    "Webcamoid.pro"
    "INSTALLQMLDIR=${placeholder "out"}/lib/qt/qml"
  ];

  meta = with stdenv.lib; {
    description = "Webcam Capture Software";
    longDescription = "Webcamoid is a full featured and multiplatform webcam suite.";
    homepage = "https://github.com/webcamoid/webcamoid/";
    license = [ licenses.gpl3Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ robaca ];
  };
}
