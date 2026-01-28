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
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sonic-visualiser";
  version = "5.2.1";

  src = fetchurl {
    url = "https://github.com/sonic-visualiser/sonic-visualiser/releases/download/sv_v${finalAttrs.version}/sonic-visualiser-${finalAttrs.version}.tar.gz";
    hash = "sha256-LzOK8CMekwU5xeXgTax8M4QleGbMKf2hEiFfjEEImMk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    bzip2
    capnproto
    fftw
    fftwFloat
    libfishsound
    libid3tag
    libjack2
    liblo
    libmad
    liboggz
    libpulseaudio
    libsamplerate
    libsndfile
    libX11
    lrdf
    opusfile
    qt6.qtbase
    qt6.qtsvg
    redland
    rubberband
    serd
    sord
    vamp-plugin-sdk
  ];

  patches = [
    ./fix-atomic-qt.patch
    ./fix-modifier-names.patch
  ];

  enableParallelBuilding = true;

  meta = {
    description = "View and analyse contents of music audio files";
    homepage = "https://www.sonicvisualiser.org/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ marcweber ];
    platforms = lib.platforms.linux;
    mainProgram = "sonic-visualiser";
  };
})
