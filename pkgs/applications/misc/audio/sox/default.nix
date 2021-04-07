{ config, lib, stdenv, fetchurl, pkg-config, CoreAudio
, enableAlsa ? true, alsaLib ? null
, enableLibao ? true, libao ? null
, enableLame ? config.sox.enableLame or false, lame ? null
, enableLibmad ? true, libmad ? null
, enableLibogg ? true, libogg ? null, libvorbis ? null
, enableOpusfile ? true, opusfile ? null
, enableFLAC ? true, flac ? null
, enablePNG ? true, libpng ? null
, enableLibsndfile ? true, libsndfile ? null
, enableWavpack ? true, wavpack ? null
# amrnb and amrwb are unfree, disabled by default
, enableAMR ? false, amrnb ? null, amrwb ? null
, enableLibpulseaudio ? true, libpulseaudio ? null
}:

with lib;

stdenv.mkDerivation rec {
  name = "sox-14.4.2";

  src = fetchurl {
    url = "mirror://sourceforge/sox/${name}.tar.gz";
    sha256 = "0v2znlxkxxcd3f48hf3dx9pq7i6fdhb62kgj7wv8xggz8f35jpxl";
  };

  # configure.ac uses pkg-config only to locate libopusfile
  nativeBuildInputs = optional enableOpusfile pkg-config;

  patches = [ ./0001-musl-rewind-pipe-workaround.patch ];

  buildInputs =
    optional (enableAlsa && stdenv.isLinux) alsaLib ++
    optional enableLibao libao ++
    optional enableLame lame ++
    optional enableLibmad libmad ++
    optionals enableLibogg [ libogg libvorbis ] ++
    optional enableOpusfile opusfile ++
    optional enableFLAC flac ++
    optional enablePNG libpng ++
    optional enableLibsndfile libsndfile ++
    optional enableWavpack wavpack ++
    optionals enableAMR [ amrnb amrwb ] ++
    optional enableLibpulseaudio libpulseaudio ++
    optional (stdenv.isDarwin) CoreAudio;

  meta = {
    description = "Sample Rate Converter for audio";
    homepage = "http://sox.sourceforge.net/";
    maintainers = [ lib.maintainers.marcweber ];
    license = if enableAMR then lib.licenses.unfree else lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
