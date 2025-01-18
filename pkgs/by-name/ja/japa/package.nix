{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  libjack2,
  fftwFloat,
  libclthreads,
  libclxclient,
  libX11,
  libXft,
  zita-alsa-pcmi,
}:

stdenv.mkDerivation rec {
  version = "0.9.4";
  pname = "japa";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/${pname}-${version}.tar.bz2";
    sha256 = "sha256-t9wlZr+pE5u6yTpATWDQseC/rf4TFbtG0X9tnTdkB8I=";
  };

  buildInputs = [
    alsa-lib
    libjack2
    fftwFloat
    libclthreads
    libclxclient
    libX11
    libXft
    zita-alsa-pcmi
  ];

  preConfigure = ''
    cd ./source/
  '';

  makeFlags = [
    "PREFIX=$(out)"
    "SUFFIX=''"
  ];

  meta = with lib; {
    description = "'perceptual' or 'psychoacoustic' audio spectrum analyser for JACK and ALSA";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/index.html";
    license = licenses.gpl2;
    maintainers = [ maintainers.magnetophon ];
    platforms = platforms.linux;
    mainProgram = "japa";
  };
}
