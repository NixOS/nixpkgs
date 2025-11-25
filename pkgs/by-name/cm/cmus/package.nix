{
  config,
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  pkg-config,
  libiconv,

  alsaSupport ? stdenv.hostPlatform.isLinux,
  alsa-lib ? null,
  # simple fallback for everyone else
  aoSupport ? !stdenv.hostPlatform.isLinux,
  libao ? null,
  jackSupport ? false,
  libjack2 ? null,
  samplerateSupport ? jackSupport,
  libsamplerate ? null,
  ossSupport ? false,
  alsa-oss ? null,
  pulseaudioSupport ? config.pulseaudio or false,
  libpulseaudio ? null,
  sndioSupport ? false,
  sndio ? null,
  mprisSupport ? stdenv.hostPlatform.isLinux,
  systemd ? null,

  # TODO: add these
  #, artsSupport
  #, roarSupport
  #, sunSupport
  #, waveoutSupport

  cddbSupport ? true,
  libcddb ? null,
  cdioSupport ? true,
  libcdio ? null,
  libcdio-paranoia ? null,
  cueSupport ? true,
  libcue ? null,
  discidSupport ? false,
  libdiscid ? null,
  ffmpegSupport ? true,
  ffmpeg_7 ? null,
  flacSupport ? true,
  flac ? null,
  madSupport ? true,
  libmad ? null,
  mikmodSupport ? true,
  libmikmod ? null,
  modplugSupport ? true,
  libmodplug ? null,
  mpcSupport ? true,
  libmpcdec ? null,
  tremorSupport ? false,
  tremor ? null,
  vorbisSupport ? true,
  libvorbis ? null,
  wavpackSupport ? true,
  wavpack ? null,
  opusSupport ? true,
  opusfile ? null,

  aacSupport ? false,
  faad2 ? null, # already handled by ffmpeg
  mp4Support ? false,
  mp4v2 ? null, # ffmpeg does support mp4 better

# not in nixpkgs
#, vtxSupport ? true, libayemu ? null
}:

assert samplerateSupport -> jackSupport;

# vorbis and tremor are mutually exclusive
assert vorbisSupport -> !tremorSupport;
assert tremorSupport -> !vorbisSupport;

let
  # https://github.com/cmus/cmus/issues/1459
  ffmpeg = ffmpeg_7;

  mkFlag =
    b: f: dep:
    if b then
      {
        flags = [ f ];
        deps = [ dep ];
      }
    else
      {
        flags = [ ];
        deps = [ ];
      };

  opts = [
    # Audio output
    (mkFlag alsaSupport "CONFIG_ALSA=y" alsa-lib)
    (mkFlag aoSupport "CONFIG_AO=y" libao)
    (mkFlag jackSupport "CONFIG_JACK=y" libjack2)
    (mkFlag samplerateSupport "CONFIG_SAMPLERATE=y" libsamplerate)
    (mkFlag ossSupport "CONFIG_OSS=y" alsa-oss)
    (mkFlag pulseaudioSupport "CONFIG_PULSE=y" libpulseaudio)
    (mkFlag sndioSupport "CONFIG_SNDIO=y" sndio)
    (mkFlag mprisSupport "CONFIG_MPRIS=y" systemd)

    #(mkFlag artsSupport "CONFIG_ARTS=y")
    #(mkFlag roarSupport "CONFIG_ROAR=y")
    #(mkFlag sunSupport "CONFIG_SUN=y")
    #(mkFlag waveoutSupport "CONFIG_WAVEOUT=y")

    # Input file formats
    (mkFlag cddbSupport "CONFIG_CDDB=y" libcddb)
    (mkFlag cdioSupport "CONFIG_CDIO=y" [
      libcdio
      libcdio-paranoia
    ])
    (mkFlag cueSupport "CONFIG_CUE=y" libcue)
    (mkFlag discidSupport "CONFIG_DISCID=y" libdiscid)
    (mkFlag ffmpegSupport "CONFIG_FFMPEG=y" ffmpeg)
    (mkFlag flacSupport "CONFIG_FLAC=y" flac)
    (mkFlag madSupport "CONFIG_MAD=y" libmad)
    (mkFlag mikmodSupport "CONFIG_MIKMOD=y" libmikmod)
    (mkFlag modplugSupport "CONFIG_MODPLUG=y" libmodplug)
    (mkFlag mpcSupport "CONFIG_MPC=y" libmpcdec)
    (mkFlag tremorSupport "CONFIG_TREMOR=y" tremor)
    (mkFlag vorbisSupport "CONFIG_VORBIS=y" libvorbis)
    (mkFlag wavpackSupport "CONFIG_WAVPACK=y" wavpack)
    (mkFlag opusSupport "CONFIG_OPUS=y" opusfile)

    (mkFlag mp4Support "CONFIG_MP4=y" mp4v2)
    (mkFlag aacSupport "CONFIG_AAC=y" faad2)

    #(mkFlag vtxSupport "CONFIG_VTX=y" libayemu)
  ];
in

stdenv.mkDerivation rec {
  pname = "cmus";
  version = "2.12.0";

  src = fetchFromGitHub {
    owner = "cmus";
    repo = "cmus";
    rev = "v${version}";
    hash = "sha256-8hgibGtkiwzenMI9YImIApRmw2EzTwE6RhglALpUkp4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    ncurses
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libiconv
  ]
  ++ lib.flatten (lib.concatMap (a: a.deps) opts);

  prefixKey = "prefix=";

  configureFlags = [
    "CONFIG_WAV=y"
    "HOSTCC=${stdenv.cc.targetPrefix}cc"
  ]
  ++ lib.concatMap (a: a.flags) opts;

  makeFlags = [ "LD=$(CC)" ];

  meta = {
    description = "Small, fast and powerful console music player for Linux and *BSD";
    homepage = "https://cmus.github.io/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ oxij ];
    platforms = with lib.platforms; linux ++ darwin;
  };
}
