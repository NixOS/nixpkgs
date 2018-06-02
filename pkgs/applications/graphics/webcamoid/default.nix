{ stdenv, qtbase, qtdeclarative, qtsvg
, qtquickcontrols, qtquickcontrols2
, libav, libpulseaudio, fetchFromGitHub
, qmake
}:
stdenv.mkDerivation rec{
  name = "webcamoid-${version}";
  version = "8.1.0";
  src = fetchFromGitHub {
    owner = "webcamoid";
    repo = "webcamoid";
    rev = "${version}";
    sha256 = "1vlga3ssqrqraimb58y4xnb35p10ichrnab8f5rqpyk8661hy9mx";
  };
  buildInputs = [
    qtbase qtdeclarative qtsvg
    qtquickcontrols qtquickcontrols2
    libav libpulseaudio
  ];
  nativeBuildInputs = [ qmake ];
  meta = {
    mantainers = [];
    description = "a full featured webcam capture application";
    platforms = stdenv.lib.platforms.linux;
  };
}
