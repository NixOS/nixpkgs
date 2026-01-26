{
  lib,
  stdenv,
  fetchurl,
  fetchpatch2,
  alsa-lib,
  boost,
  bzip2,
  fftw,
  fftwFloat,
  libfishsound,
  libid3tag,
  liblo,
  libmad,
  liboggz,
  libpulseaudio,
  libsamplerate,
  libsndfile,
  lrdf,
  opusfile,
  portaudio,
  rubberband,
  serd,
  sord,
  capnproto,
  pkg-config,
  libjack2,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sonic-lineup";
  version = "1.1";

  src = fetchurl {
    url = "https://code.soundsoftware.ac.uk/attachments/download/2765/sonic-lineup-${finalAttrs.version}.tar.gz";
    sha256 = "0k45k9fawcm4s5yy05x00pgww7j8m7k2cxcc7g0fn9vqy7vcbq9h";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/sonic-visualiser/svcore/commit/5a7b517e43b7f0b3f03b7fc3145102cf4e5b0ffc.patch";
      stripLen = 1;
      extraPrefix = "svcore/";
      sha256 = "sha256-DOCdQqCihkR0g/6m90DbJxw00QTpyVmFzCxagrVWKiI=";
    })
    ./match-vamp.patch
  ];

  buildInputs = [
    alsa-lib
    boost
    bzip2
    fftw
    fftwFloat
    libfishsound
    libid3tag
    liblo
    libmad
    liboggz
    libpulseaudio
    libsamplerate
    libsndfile
    lrdf
    opusfile
    portaudio
    rubberband
    serd
    sord
    capnproto
    libjack2
  ];

  nativeBuildInputs = [
    capnproto # capnp
    pkg-config
    libsForQt5.wrapQtAppsHook
  ];

  strictDeps = true;

  enableParallelBuilding = true;

  # comment out the tests
  preConfigure = ''
    sed -i 's/sub_test_svcore_/#sub_test_svcore_/' sonic-lineup.pro
  '';

  meta = {
    description = "Comparative visualisation of related audio recordings";
    mainProgram = "sonic-lineup";
    homepage = "https://www.sonicvisualiser.org/sonic-lineup/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ vandenoever ];
    platforms = lib.platforms.linux;
  };
})
