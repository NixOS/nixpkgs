{
  lib,
  config,
  clangStdenv,
  fetchFromGitHub,
  autoreconfHook,
  libtool,
  intltool,
  pkg-config,
  jansson,
  swift-corelibs-libdispatch,
  gtk3,
  gsettings-desktop-schemas,
  wrapGAppsHook3,
  # input plugins
  vorbisSupport ? true,
  libvorbis,
  mp123Support ? true,
  libmad,
  flacSupport ? true,
  flac,
  wavSupport ? true,
  libsndfile,
  cdaSupport ? true,
  libcdio,
  libcddb,
  aacSupport ? true,
  faad2,
  opusSupport ? true,
  opusfile,
  wavpackSupport ? false,
  wavpack,
  ffmpegSupport ? false,
  ffmpeg,
  apeSupport ? true,
  yasm,
  # misc plugins
  zipSupport ? true,
  libzip,
  artworkSupport ? true,
  imlib2,
  hotkeysSupport ? true,
  libX11,
  osdSupport ? true,
  dbus,
  # output plugins
  alsaSupport ? true,
  alsa-lib,
  pulseSupport ? config.pulseaudio or true,
  libpulseaudio,
  pipewireSupport ? true,
  pipewire,
  # effect plugins
  resamplerSupport ? true,
  libsamplerate,
  overloadSupport ? true,
  zlib,
  # transports
  remoteSupport ? true,
  curl,
}:

let
  inherit (lib) optionals;
in
clangStdenv.mkDerivation (finalAttrs: {
  pname = "deadbeef";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner = "DeaDBeeF-Player";
    repo = "deadbeef";
    fetchSubmodules = true;
    tag = finalAttrs.version;
    hash = "sha256-qa0ULmE15lV2vkyXPNW9kSISQZEANrjwJwykTiifk5Q=";
  };

  buildInputs = [
    jansson
    swift-corelibs-libdispatch
    gtk3
    gsettings-desktop-schemas
  ]
  ++ optionals vorbisSupport [
    libvorbis
  ]
  ++ optionals mp123Support [
    libmad
  ]
  ++ optionals flacSupport [
    flac
  ]
  ++ optionals wavSupport [
    libsndfile
  ]
  ++ optionals cdaSupport [
    libcdio
    libcddb
  ]
  ++ optionals aacSupport [
    faad2
  ]
  ++ optionals opusSupport [
    opusfile
  ]
  ++ optionals zipSupport [
    libzip
  ]
  ++ optionals ffmpegSupport [
    ffmpeg
  ]
  ++ optionals apeSupport [
    yasm
  ]
  ++ optionals artworkSupport [
    imlib2
  ]
  ++ optionals hotkeysSupport [
    libX11
  ]
  ++ optionals osdSupport [
    dbus
  ]
  ++ optionals alsaSupport [
    alsa-lib
  ]
  ++ optionals pulseSupport [
    libpulseaudio
  ]
  ++ optionals pipewireSupport [
    pipewire
  ]
  ++ optionals resamplerSupport [
    libsamplerate
  ]
  ++ optionals overloadSupport [
    zlib
  ]
  ++ optionals wavpackSupport [
    wavpack
  ]
  ++ optionals remoteSupport [
    curl
  ];

  nativeBuildInputs = [
    autoreconfHook
    intltool
    libtool
    pkg-config
    wrapGAppsHook3
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Ultimate Music Player for GNU/Linux";
    mainProgram = "deadbeef";
    homepage = "http://deadbeef.sourceforge.net/";
    downloadPage = "https://github.com/DeaDBeeF-Player/deadbeef";
    license = lib.licenses.gpl2;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = [ ];
  };
})
