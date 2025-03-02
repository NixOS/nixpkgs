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
  fetchpatch,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dsp";
  version = "1.9";

  src = fetchFromGitHub {
    owner = "bmc0";
    repo = "dsp";
    rev = "v${finalAttrs.version}";
    hash = "sha256-S1pzVQ/ceNsx0vGmzdDWw2TjPVLiRgzR4edFblWsekY=";
  };

  nativeBuildInputs = [ pkg-config ];

  patches = [
    # fix compatibility with ffmpeg7
    # https://github.com/bmc0/dsp/commit/58a9d0c1f99f2d4c7fc51b6dbe563447ec60120f
    (fetchpatch {
      url = "https://github.com/bmc0/dsp/commit/58a9d0c1f99f2d4c7fc51b6dbe563447ec60120f.patch?full_index=1";
      hash = "sha256-7WgJegDL9sVCRnRwm/f1ZZl2eiuRT5oAQaYoDLjEoqs=";
    })
  ];

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
