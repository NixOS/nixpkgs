{ config
, lib
, stdenv
, fetchurl
, pkg-config
, CoreAudio
, enableAlsa ? true
, alsa-lib
, enableLibao ? true
, libao
, enableLame ? config.sox.enableLame or false
, lame
, enableLibmad ? true
, libmad
, enableLibogg ? true
, libogg
, libvorbis
, enableOpusfile ? true
, opusfile
, enableFLAC ? true
, flac
, enablePNG ? true
, libpng
, enableLibsndfile ? true
, libsndfile
, enableWavpack ? true
, wavpack
  # amrnb and amrwb are unfree, disabled by default
, enableAMR ? false
, amrnb
, amrwb
, enableLibpulseaudio ? stdenv.isLinux
, libpulseaudio
}:

stdenv.mkDerivation rec {
  pname = "sox";
  version = "14.4.2";

  src = fetchurl {
    url = "mirror://sourceforge/sox/sox-${version}.tar.gz";
    sha256 = "0v2znlxkxxcd3f48hf3dx9pq7i6fdhb62kgj7wv8xggz8f35jpxl";
  };

  # configure.ac uses pkg-config only to locate libopusfile
  nativeBuildInputs = lib.optional enableOpusfile pkg-config;

  patches = [ ./0001-musl-rewind-pipe-workaround.patch ];

  buildInputs =
    lib.optional (enableAlsa && stdenv.isLinux) alsa-lib
    ++ lib.optional enableLibao libao
    ++ lib.optional enableLame lame
    ++ lib.optional enableLibmad libmad
    ++ lib.optionals enableLibogg [ libogg libvorbis ]
    ++ lib.optional enableOpusfile opusfile
    ++ lib.optional enableFLAC flac
    ++ lib.optional enablePNG libpng
    ++ lib.optional enableLibsndfile libsndfile
    ++ lib.optional enableWavpack wavpack
    ++ lib.optionals enableAMR [ amrnb amrwb ]
    ++ lib.optional enableLibpulseaudio libpulseaudio
    ++ lib.optional stdenv.isDarwin CoreAudio;

  meta = with lib; {
    description = "Sample Rate Converter for audio";
    homepage = "http://sox.sourceforge.net/";
    maintainers = with maintainers; [ marcweber ];
    license = if enableAMR then licenses.unfree else licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
