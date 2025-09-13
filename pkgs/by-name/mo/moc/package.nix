{
  lib,
  stdenv,
  fetchsvn,
  fetchpatch2,
  pkg-config,
  autoreconfHook,
  autoconf-archive,
  ncurses,
  db,
  popt,
  libtool,
  libiconv,
  # Sound sub-systems
  alsaSupport ? (!stdenv.hostPlatform.isDarwin),
  alsa-lib,
  pulseSupport ? true,
  libpulseaudio,
  jackSupport ? true,
  libjack2,
  ossSupport ? true,
  # Audio formats
  aacSupport ? true,
  faad2,
  libid3tag,
  flacSupport ? true,
  flac,
  midiSupport ? true,
  timidity,
  modplugSupport ? true,
  libmodplug,
  mp3Support ? true,
  libmad,
  musepackSupport ? true,
  libmpc,
  libmpcdec,
  taglib,
  vorbisSupport ? true,
  libvorbis,
  speexSupport ? true,
  speex,
  ffmpegSupport ? true,
  ffmpeg,
  sndfileSupport ? true,
  libsndfile,
  wavpackSupport ? true,
  wavpack,
  # Misc
  curlSupport ? true,
  curl,
  samplerateSupport ? true,
  libsamplerate,
  withDebug ? false,
}:

stdenv.mkDerivation {
  pname = "moc";
  version = "2.6-alpha3-unstable-2019-09-14";

  src = fetchsvn {
    url = "svn://svn.daper.net/moc/trunk";
    rev = "3005";
    hash = "sha256-JksJxHQgQ8hPTFtLvEvZuFh2lflDNrEmDTMWWwVnjZQ=";
  };

  patches = [
    # FFmpeg 6 support
    (fetchpatch2 {
      url = "https://cygwin.com/cgit/cygwin-packages/moc/plain/Support-for-recent-ffmpeg-change.patch?id=ab70f1306b8416852915be4347003aac3bdc216";
      hash = "sha256-5hLEFBJ+7Nvxn6pNj4bngcg2qJsCzxiuP6yEj+7tvs0=";
      stripLen = 1;
    })

    # FFmpeg 7 support
    (fetchpatch2 {
      url = "https://cygwin.com/cgit/cygwin-packages/moc/plain/ffmpeg-7.0.patch?id=ab70f1306b8416852915be4347003aac3bdc216e";
      hash = "sha256-dYw6DNyw61MGfv+GdBz5Dtrr9fVph1tf7vxexWONwF8=";
      stripLen = 1;
    })

    ./use-ax-check-compile-flag.patch
  ]
  ++ lib.optional pulseSupport ./pulseaudio.patch;

  postPatch = ''
    rm m4/*
  '';

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    autoconf-archive
  ];

  buildInputs = [
    ncurses
    db
    popt
    libtool
  ]
  # Sound sub-systems
  ++ lib.optional alsaSupport alsa-lib
  ++ lib.optional pulseSupport libpulseaudio
  ++ lib.optional jackSupport libjack2
  # Audio formats
  ++ lib.optional (aacSupport || mp3Support) libid3tag
  ++ lib.optional aacSupport faad2
  ++ lib.optional flacSupport flac
  ++ lib.optional midiSupport timidity
  ++ lib.optional modplugSupport libmodplug
  ++ lib.optional mp3Support libmad
  ++ lib.optionals musepackSupport [
    libmpc
    libmpcdec
    taglib
  ]
  ++ lib.optional vorbisSupport libvorbis
  ++ lib.optional speexSupport speex
  ++ lib.optional ffmpegSupport ffmpeg
  ++ lib.optional sndfileSupport libsndfile
  ++ lib.optional wavpackSupport wavpack
  # Misc
  ++ lib.optional curlSupport curl
  ++ lib.optional samplerateSupport libsamplerate
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ];

  configureFlags = [
    # Sound sub-systems
    (lib.withFeature alsaSupport "alsa")
    (lib.withFeature pulseSupport "pulse")
    (lib.withFeature jackSupport "jack")
    (lib.withFeature ossSupport "oss")
    # Audio formats
    (lib.withFeature aacSupport "aac")
    (lib.withFeature flacSupport "flac")
    (lib.withFeature midiSupport "timidity")
    (lib.withFeature modplugSupport "modplug")
    (lib.withFeature mp3Support "mp3")
    (lib.withFeature musepackSupport "musepack")
    (lib.withFeature vorbisSupport "vorbis")
    (lib.withFeature speexSupport "speex")
    (lib.withFeature ffmpegSupport "ffmpeg")
    (lib.withFeature sndfileSupport "sndfile")
    (lib.withFeature wavpackSupport "wavpack")
    # Misc
    (lib.withFeature curlSupport "curl")
    (lib.withFeature samplerateSupport "samplerate")
    ("--enable-debug=" + (if withDebug then "yes" else "no"))
    "--disable-cache"
    "--without-rcc"
  ];

  meta = with lib; {
    description = "Terminal audio player designed to be powerful and easy to use";
    homepage = "http://moc.daper.net/";
    license = licenses.gpl2;
    maintainers = with maintainers; [
      aethelz
      pSub
      jagajaga
    ];
    platforms = platforms.unix;
    mainProgram = "mocp";
  };
}
