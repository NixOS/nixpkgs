{
  lib,
  stdenv,
  autoreconfHook,
  pkg-config,
  fetchFromGitHub,
  fetchpatch,
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
  monkeys-audio,
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
  strictDeps = true;
  __structuredAttrs = true;
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
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
  ++ lib.optional enableMac monkeys-audio
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
  patches =
    [ ]
    # use avcodec_free_context in place of avcodec_close in supported versions of ffmpeg
    ++ lib.optional (lib.versionAtLeast ffmpeg.version "3.3") (fetchpatch {
      url = "https://github.com/jeremyevans/aqualung/commit/d830ac5898412280ea02faebe82509a8129dac59.patch";
      hash = "sha256-YMWlfK4242q3DoCcmfIeP3xQk2Ot05ifs2AN5CCDcco=";
    });
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
    '';
  };
})
