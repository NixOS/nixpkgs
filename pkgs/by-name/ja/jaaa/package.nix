{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  libclthreads,
  libclxclient,
  libx11,
  libxft,
  libxrender,
  fftwFloat,
  libjack2,
  zita-alsa-pcmi,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jaaa";
  version = "0.9.2";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/jaaa-${finalAttrs.version}.tar.bz2";
    sha256 = "1czksxx2g8na07k7g57qlz0vvkkgi5bzajcx7vc7jhb94hwmmxbc";
  };

  buildInputs = [
    alsa-lib
    libclthreads
    libclxclient
    libx11
    libxft
    libxrender
    fftwFloat
    libjack2
    zita-alsa-pcmi
  ];

  makeFlags = [
    "PREFIX=$(out)"
    "SUFFIX=''"
  ];

  preConfigure = ''
    cd ./source/
  '';

  meta = {
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/index.html";
    description = "JACK and ALSA Audio Analyser";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.magnetophon ];
    platforms = lib.platforms.linux;
    mainProgram = "jaaa";
  };
})
