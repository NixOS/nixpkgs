{
  lib,
  config,
  clangStdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  intltool,
  pkg-config,
  jansson,
  swift-corelibs-libdispatch,
  # deadbeef can use either gtk2 or gtk3
  gtk2Support ? false,
  gtk2,
  gtk3Support ? true,
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

assert gtk2Support || gtk3Support;

let
  inherit (lib) optionals;

  version = "1.10.0";
in
clangStdenv.mkDerivation {
  pname = "deadbeef";
  inherit version;

  src = fetchFromGitHub {
    owner = "DeaDBeeF-Player";
    repo = "deadbeef";
    fetchSubmodules = true;
    rev = version;
    hash = "sha256-qa0ULmE15lV2vkyXPNW9kSISQZEANrjwJwykTiifk5Q=";
  };

  buildInputs = [
    jansson
    swift-corelibs-libdispatch
  ]
  ++ optionals gtk2Support [
    gtk2
  ]
  ++ optionals gtk3Support [
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
    autoconf
    automake
    intltool
    libtool
    pkg-config
  ]
  ++ optionals gtk3Support [
    wrapGAppsHook3
  ];

  enableParallelBuilding = true;

  preConfigure = ''
    ./autogen.sh
  '';

  postPatch = ''
    # Fix the build on c++17 compiler:
    #   https://github.com/DeaDBeeF-Player/deadbeef/issues/3012
    # TODO: remove after 1.9.5 release.
    substituteInPlace plugins/adplug/Makefile.am --replace 'adplug_la_CXXFLAGS = ' 'adplug_la_CXXFLAGS = -std=c++11 '
  '';

  meta = with lib; {
    description = "Ultimate Music Player for GNU/Linux";
    mainProgram = "deadbeef";
    homepage = "http://deadbeef.sourceforge.net/";
    downloadPage = "https://github.com/DeaDBeeF-Player/deadbeef";
    license = licenses.gpl2;
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
    maintainers = [ ];
  };
}
