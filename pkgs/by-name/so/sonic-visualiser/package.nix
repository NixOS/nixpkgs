# TODO add plugins having various licenses, see http://www.vamp-plugins.org/download.html

{
  lib,
  stdenv,
  fetchurl,
  alsa-lib,
  bzip2,
  fftw,
  libjack2,
  libX11,
  liblo,
  libmad,
  lrdf,
  libsamplerate,
  libsndfile,
  pkg-config,
  libpulseaudio,
  redland,
  rubberband,
  serd,
  sord,
  vamp-plugin-sdk,
  fftwFloat,
  capnproto,
  liboggz,
  libfishsound,
  libid3tag,
  opusfile,
  meson,
  ninja,
  cmake,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sonic-visualiser";
  version = "4.5.1";

  src = fetchurl {
    url = "https://code.soundsoftware.ac.uk/attachments/download/2841/sonic-visualiser-${finalAttrs.version}.tar.gz";
    hash = "sha256-WauIaCWQs739IwJIorDCNymH//navxsbHUCVAUYl7+k=";
  };

  nativeBuildInputs = [
    meson
    ninja
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [
    libsndfile
    libsForQt5.qtbase
    libsForQt5.qtsvg
    fftw
    fftwFloat
    bzip2
    lrdf
    rubberband
    libsamplerate
    vamp-plugin-sdk
    alsa-lib
    redland
    serd
    sord
    # optional
    libjack2
    # portaudio
    libpulseaudio
    libmad
    libfishsound
    liblo
    libX11
    capnproto
    liboggz
    libid3tag
    opusfile
  ];

  enableParallelBuilding = true;

  meta = {
    description = "View and analyse contents of music audio files";
    homepage = "https://www.sonicvisualiser.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ marcweber ];
    platforms = lib.platforms.linux;
  };
})
