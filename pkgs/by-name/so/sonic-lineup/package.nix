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
  libjack2,
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
  libsForQt5,
  pkg-config,
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
      url = "https://github.com/sonic-visualiser/svcore/commit/5a7b517e43b7f0b3f03b7fc3145102cf4e5b0ffc.patch?full_index=1";
      stripLen = 1;
      extraPrefix = "svcore/";
      hash = "sha256-ReFOGRyM7IXKOUuzNoGIVX+C+zMz3/fftQN7k5BHp0k=";
    })
    ./match-vamp.patch
    (fetchpatch2 {
      url = "https://github.com/piper-audio/piper-vamp-cpp/commit/6f16a09b78b995b3cf2844f00033bde90e5e0936.patch?full_index=1";
      stripLen = 1;
      extraPrefix = "piper-vamp-cpp/";
      hash = "sha256-G9O9t1Niesffj4bDFO0q8KMgygTdYJUVHkq/7nkGSRk=";
    })
  ];

  buildInputs = [
    alsa-lib
    boost
    bzip2
    capnproto
    fftw
    fftwFloat
    libfishsound
    libid3tag
    libjack2
    libsForQt5.qtbase
    libsForQt5.qtsvg
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
  ];

  nativeBuildInputs = [
    capnproto # capnp
    libsForQt5.wrapQtAppsHook
    pkg-config
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
