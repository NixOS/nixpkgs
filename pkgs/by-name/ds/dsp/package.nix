{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  fftw,
  zita-convolver,
  fftwFloat,
  libsndfile,
  ffmpeg,
  alsa-lib,
  libao,
  libmad,
  ladspaH,
  libtool,
  libpulseaudio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dsp";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "bmc0";
    repo = "dsp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WUH4+5v1wv6EXTOuRq9iVVZsXMt5DVrtgX8vLE7a8s8=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    fftw
    zita-convolver
    fftwFloat
    libsndfile
    ffmpeg
    alsa-lib
    libao
    libmad
    ladspaH
    libtool
    libpulseaudio
  ];

  meta = {
    homepage = "https://github.com/bmc0/dsp";
    description = "Audio processing program with an interactive mode";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ aaronjheng ];
    platforms = lib.platforms.linux;
    mainProgram = "dsp";
  };
})
