{
  lib,
  stdenv,
  autoreconfHook,
  pkg-config,
  fetchFromGitHub,
  nix-update-script,

  # Mandatory
  gtk3,
  libxml2,

  # Optional
  enableLadspa ? true,
  lrdf,
  enableCdda ? true,
  libcdio,
  libcdio-paranoia,
  enableCddb ? true,
  libcddb,
  enableSrc ? true,
  libsamplerate,
  # enableIfp ? true, # FIXME: find the right dependency to support the iRiver iFP driver if it exists in nixpkgs
  enableLua ? true,
  lua,

  # File I/O
  enableSndfile ? true,
  libsndfile,
  enableFlac ? true,
  flac,
  enableVorbis ? true,
  libvorbis,
  enableSpeex ? true,
  liboggz,
  speex,
  enableMpeg ? true,
  libmad,
  enableLame ? true,
  lame,
  enableMod ? true,
  libmodplug,
  enableMpc ? true,
  libmpcdec,
  enableMac ? true,
  monkeysAudio,
  enableWavpack ? true,
  wavpack,
  enableLavc ? true,
  ffmpeg,

  # Output
  enableSndio ? true,
  sndio,
  enableAlsa ? true,
  alsa-lib,
  enableJack ? true,
  libjack2,
  enablePulse ? true,
  pulseaudio,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "aqualung";
  version = "2.0";
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs =
    [
      gtk3
      libxml2
    ]
    ++ lib.optional enableLadspa lrdf
    ++ lib.optionals enableCdda [
      libcdio
      libcdio-paranoia
    ]
    ++ lib.optional enableCddb libcddb
    ++ lib.optional enableSrc libsamplerate
    ++ lib.optional enableLua lua

    ++ lib.optional enableSndfile libsndfile
    ++ lib.optional enableFlac flac
    ++ lib.optional enableVorbis libvorbis
    ++ lib.optionals enableSpeex [
      liboggz
      speex
    ]
    ++ lib.optional enableMpeg libmad
    ++ lib.optional enableLame lame
    ++ lib.optional enableMod libmodplug
    ++ lib.optional enableMpc libmpcdec
    ++ lib.optional enableMac monkeysAudio
    ++ lib.optional enableWavpack wavpack
    ++ lib.optional enableLavc ffmpeg

    ++ lib.optional enableSndio sndio
    ++ lib.optional enableAlsa alsa-lib
    ++ lib.optional enableJack libjack2
    ++ lib.optional enablePulse pulseaudio;
  src = fetchFromGitHub {
    owner = "jeremyevans";
    repo = "aqualung";
    tag = finalAttrs.version;
    hash = "sha256-jUz5iOvXJTxsF4EA35RyxBawcen+flULlpZs9p67YsA=";
  };
  passthru.updateScript = nix-update-script { };
  meta = {
    homepage = "https://aqualung.jeremyevans.net/";
    description = "Gapless music player";
    license = lib.licenses.gpl2Plus;
    mainProgram = "aqualung";
    maintainers = with lib.maintainers; [ amiryal ];
    platforms = lib.platforms.all;

    # Source for longDescription: https://github.com/jeremyevans/aqualung/blob/5e0226f7ddd871be4fc4f0854a5e125bde3d7918/index.md
    # (Converted with html2markdown from nixpkgs#html2text.)
    longDescription = ''
      Aqualung is an advanced music player originally targeted at the GNU/Linux
      operating system, today also running on FreeBSD and OpenBSD, with native ports
      to Mac OS X and even Microsoft Windows. It plays audio CDs, internet radio
      streams and podcasts as well as soundfiles in just about any audio format and
      has the feature of _**inserting no gaps**_ between adjacent tracks.

      ## Features at a glance

      ### On the input side:

        * Audio CDs can be played back and ripped to the Music Store with on-the-fly conversion to WAV, FLAC, Ogg Vorbis or CBR/VBR MP3 (gapless via LAME). Seamless tagging of the created files is offered as part of the process.
        * Internet radio stations streaming Ogg Vorbis or MP3 are supported.
        * Subscribing to RSS and Atom audio podcasts is supported. Aqualung can automatically download and add new files to the Music Store. Optional limits for the age, size and number of downloaded files can be set.
        * Almost all sample-based, uncompressed formats (e.g. WAV, AIFF, AU etc.) are supported. For the full list of these formats, visit the [libsndfile](http://www.mega-nerd.com/libsndfile/) homepage.
        * Files encoded with [FLAC](http://flac.sourceforge.net/) (the Free Lossless Audio Codec) are supported.
        * [Ogg Vorbis](http://www.vorbis.com/) and Ogg [Speex](http://speex.org/) audio files are supported.
        * MPEG Audio files are supported. This includes MPEG 1-2-2.5, Layer I-II-III encoded audio, including the infamous MPEG-1 Layer III format also known as MP3. For tracks containing the appropriate LAME headers, the MPEG encoder delay and padding is eliminated by Aqualung, resulting in truly gapless playback. Aqualung also supports VBR (variable bitrate) and UBR (unspecified bitrate) MPEG files.
        * MOD audio files (MOD, S3M, XM, IT, etc.) are supported via the high quality libmodplug library.
        * Musepack (a.k.a. MPEG Plus) files are supported.
        * Files encoded with Monkey's Audio Codec are supported.
        * WavPack files are supported via a native decoder.
        * Numerous formats and codecs are supported via the [FFmpeg](http://ffmpeg.mplayerhq.hu/) project, including AC3, AAC, WMA, WavPack and the soundtrack of many video formats.
        * Naturally, any of these files can be mono or stereo.

      ### On the output side:

        * OSS driver support
        * ALSA driver support
        * [JACK](http://jackaudio.org/) Audio Server support
        * [PulseAudio](http://pulseaudio.org/) support
        * sndio output (presently available on OpenBSD only)
        * Win32 Sound API (available only under native Win32 or [Cygwin](http://cygwin.com/))
        * Exporting files to external formats from Playlist and Music Store is supported.

      ### In between:

        * Continuous, gap-free playback of consecutive tracks. Your ears get exactly what is in the files – no silence inserted in between.
        * Ability to convert sample rates between the input file and the output device, from downsampling by a factor of 12 to upsampling by the same factor. The best converter provides a signal-to-noise ratio of 97dB with -3dB passband extending from DC to 96% of the theoretical best bandwidth for a given pair of input and output sample rates.
        * [LADSPA](http://www.ladspa.org/) plugin support – you can use any suitable LADSPA plugin to enhance the music you are listening to. There are many different equalizer, spatial enhancer, tube preamp simulator etc. plugins out there. If you don't have any, [grab these](http://tap-plugins.sf.net/).

      ### Other niceties:

        * Playlist tabs allow you to have multiple playlists for your music at the same time, very similarly to multiple tabbed browsing in Firefox.
        * Internally working volume and balance controls (not touching the soundcard mixer).
        * Support for dark theme; enable it in Settings.
        * Support for random seeking during playback.
        * Track repeat, List repeat and Shuffle mode (besides normal playback). In track repeat mode the looping range is adjustable (A-B repeat). It is possible to set the looping boundaries via a single keystroke while listening to the track.
        * Ability to display and edit Ogg Xiph comments, ID3v1, ID3v2 and APE tags found in files that support them. When exporting tracks to a different file format, metadata is preserved as much as possible.
        * All windows are sizable. You can stretch the main window horizontally for more accurate seeking.
        * You can control any running instance of the program remotely from the command line (start, stop, pause etc.). Remote loading or enqueueing soundfiles as well as complete playlists is also supported.
        * State persistence via XML config files. Aqualung will come up in the same state as it was when you closed it, including playback modes, volume and balance settings, currently processing LADSPA plugins, window sizes, positions and visibility, and other miscellaneous options.

      In addition to all this, Aqualung comes with a _Music Store_ that is an XML-
      based music database, capable of storing various metadata about music on your
      computer (including, but not limited to, the names of artists, and the titles
      of records and tracks). You can (and should) organize your music into a tree
      of Artists/Records/Tracks, thereby making life easier than with the all-in-one
      Winamp/XMMS playlist. Importing file metadata (ID3v1, ID3v2 tags, Ogg Xiph
      comments, APE metadata) into the Music Store as well as getting track names
      from a CDDB/FreeDB database is supported.
    '';
  };
})
