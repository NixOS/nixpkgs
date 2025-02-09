{ config
, lib
, stdenv
, fetchgit
, autoreconfHook
, autoconf-archive
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
  version = "unstable-2021-05-09";

  src = fetchgit {
    # not really needed, but when this src was updated from `fetchurl ->
    # fetchgit`, we spared the mass rebuild by changing this `name` and
    # therefor merge this to `master` and not to `staging`.
    name = "source";
    url = "https://git.code.sf.net/p/sox/code";
    rev = "42b3557e13e0fe01a83465b672d89faddbe65f49";
    hash = "sha256-9cpOwio69GvzVeDq79BSmJgds9WU5kA/KUlAkHcpN5c=";
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
    homepage = "https://sox.sourceforge.net/";
    maintainers = with maintainers; [ marcweber ];
    license = if enableAMR then licenses.unfree else licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
