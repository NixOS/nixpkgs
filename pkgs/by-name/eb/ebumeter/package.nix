{
  lib,
  stdenv,
  fetchurl,
  libx11,
  libxft,
  libclthreads,
  libclxclient,
  libjack2,
  libpng,
  libsndfile,
  zita-resampler,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ebumeter";
  version = "0.5.1";

  src = fetchurl {
    url = "https://kokkinizita.linuxaudio.org/linuxaudio/downloads/ebumeter-${finalAttrs.version}.tar.xz";
    hash = "sha256-U2ZpNfvy+X1RdA9Q4gvFYzAxlgc6kYjJpQ/0sEX0A4I=";
  };

  buildInputs = [
    libx11
    libxft
    libclthreads
    libclxclient
    libjack2
    libpng
    libsndfile
    zita-resampler
  ];

  preConfigure = ''
    cd source
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  enableParallelBuilding = true;

  meta = {
    description = "Level metering according to the EBU R-128 recommendation";
    homepage = "http://kokkinizita.linuxaudio.org/linuxaudio/index.html";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
