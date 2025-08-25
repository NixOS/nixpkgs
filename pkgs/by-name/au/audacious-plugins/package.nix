{
  lib,
  stdenv,
  fetchFromGitHub,
  alsa-lib,
  audacious-bare,
  curl,
  faad2,
  ffmpeg,
  flac,
  fluidsynth,
  gdk-pixbuf,
  lame,
  libbs2b,
  libcddb,
  libcdio,
  libcdio-paranoia,
  libcue,
  libjack2,
  libmad,
  libmms,
  libmodplug,
  libmowgli,
  libnotify,
  libogg,
  libopenmpt,
  libpulseaudio,
  libsamplerate,
  libsidplayfp,
  libsndfile,
  libvorbis,
  libxml2,
  lirc,
  meson,
  mpg123,
  neon,
  ninja,
  pkg-config,
  opusfile,
  pipewire,
  qt6,
  soxr,
  vgmstream,
  wavpack,
}:

stdenv.mkDerivation rec {
  pname = "audacious-plugins";
  version = "4.5";

  src = fetchFromGitHub {
    owner = "audacious-media-player";
    repo = "audacious-plugins";
    rev = "${pname}-${version}";
    hash = "sha256-2GsNIkvrjZ1EOXi6H5jagdawxXp0kVg7C4FaEZkMHwM=";
  };

  patches = [ ./0001-Set-plugindir-to-PREFIX-lib-audacious.patch ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    audacious-bare
    curl
    faad2
    ffmpeg
    flac
    fluidsynth
    gdk-pixbuf
    lame
    libbs2b
    libcddb
    libcdio
    libcdio-paranoia
    libcue
    libjack2
    libmad
    libmms
    libmodplug
    libmowgli
    libnotify
    libogg
    libpulseaudio
    libsamplerate
    libsidplayfp
    libsndfile
    libvorbis
    libxml2
    mpg123
    neon
    opusfile
    qt6.qtbase
    qt6.qtmultimedia
    soxr
    wavpack
    libopenmpt
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    lirc
    pipewire
    qt6.qtwayland
  ];

  mesonFlags = [
    "-Dgtk=false"
  ];

  dontWrapQtApps = true;

  postInstall = ''
    ln -s ${vgmstream.audacious}/lib/audacious/Input/* $out/lib/audacious/Input
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-F${qt6.qtbase}/lib -iframework ${qt6.qtbase}/lib -F${qt6.qtmultimedia}/lib -iframework ${qt6.qtmultimedia}/lib";

  meta = audacious-bare.meta // {
    description = "Plugins for Audacious music player";
    downloadPage = "https://github.com/audacious-media-player/audacious-plugins";
  };
}
