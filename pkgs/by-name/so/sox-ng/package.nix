{
  config,
  lib,
  stdenv,
  fetchFromCodeberg,
  autoreconfHook,
  autoconf-archive,
  pkg-config,
  enableReplace ? true, # FIXME: or false?
  enableAMR ? true,
  opencore-amr,
  enableAlsa ? true,
  alsa-lib,
  enableFLAC ? true,
  flac,
  enableFFTW ? true,
  fftw,
  enableLadspa ? true,
  ladspa-sdk,
  enableLame ? config.sox.enableLame or false,
  lame,
  enableLibao ? true,
  libao,
  enableLibid3tag ? true,
  libid3tag,
  enableLibmad ? true,
  libmad,
  enableLibogg ? true,
  libogg,
  libvorbis,
  enableLibpulseaudio ?
    stdenv.hostPlatform.isLinux && lib.meta.availableOn stdenv.hostPlatform libpulseaudio,
  libpulseaudio,
  enableLibsndfile ? true,
  libsndfile,
  enableOpusfile ? true,
  opusfile,
  enablePNG ? true,
  libpng,
  enableSpeex ? true,
  speex,
  speexdsp,
  enableTwolame ? config.sox.enableTwolame or false,
  twolame,
  enableWavpack ? true,
  wavpack,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sox";
  version = "14.7.1";

  src = fetchFromCodeberg {
    owner = "sox_ng";
    repo = "sox_ng";
    tag = "sox_ng-${finalAttrs.version}";
    hash = "sha256-rjVZE97Xuuby+IvikVxkCj4AFPlMm62a3GBWPPfREcU=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
    "man"
  ];

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    pkg-config
  ];

  buildInputs =
    lib.optional (enableAlsa && stdenv.hostPlatform.isLinux) alsa-lib
    ++ lib.optional enableAMR opencore-amr
    ++ lib.optional enableFLAC flac
    ++ lib.optional enableFFTW fftw
    ++ lib.optional enableLadspa ladspa-sdk
    ++ lib.optional enableLame lame
    ++ lib.optional enableLibao libao
    ++ lib.optional enableLibid3tag libid3tag
    ++ lib.optional enableLibmad libmad
    ++ lib.optional enableLibpulseaudio libpulseaudio
    ++ lib.optional enableLibsndfile libsndfile
    ++ lib.optional enableOpusfile opusfile
    ++ lib.optional enablePNG libpng
    ++ lib.optional enableTwolame twolame
    ++ lib.optional enableWavpack wavpack
    ++ lib.optionals enableLibogg [
      libogg
      libvorbis
    ]
    ++ lib.optionals enableSpeex [
      speex
      speexdsp
    ];

  configureFlags = [
    (lib.enableFeature enableReplace "replace")
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Another Swiss Army Knife of sound processing utilities";
    homepage = "https://codeberg.org/sox_ng/sox_ng";
    maintainers = with lib.maintainers; [ ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
