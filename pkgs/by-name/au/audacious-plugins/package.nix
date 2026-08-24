{
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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
  libresidfp,
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
  version = "4.5.1";

  src = fetchFromGitHub {
    owner = "audacious-media-player";
    repo = "audacious-plugins";
    rev = "${pname}-${version}";
    hash = "sha256-HfO59DOIYsEpBzUyaLYh/gXfz+zvH8lIY2yBVCn3wks=";
  };

  patches = [
    ./0001-Set-plugindir-to-PREFIX-lib-audacious.patch

    # Remove when version >= 4.6
    (fetchpatch {
      name = "0001-audacious-plugins-sid-Use-new-sidplayfp-API.patch";
      url = "https://github.com/audacious-media-player/audacious-plugins/commit/42c05763a136d6523d611473ff3701e2d9e30bec.patch";
      hash = "sha256-bTC9nZFNwyo4PsGrLyDiQJDOrHTUDHUQaxEFe/wFPME=";
    })
    (fetchpatch {
      name = "0002-audacious-plugins-sid-Support-version-3.0-of-libsidplayfp-version.patch";
      url = "https://github.com/audacious-media-player/audacious-plugins/commit/2aaf45bd3840858e23b75d5863129a510299abd6.patch";
      hash = "sha256-FbGLd3aiKeoJXKgTMIdI/oBEx5EzcqyhL0jWhG6Fyfw=";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    audacious-bare
    alsa-lib
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
    libresidfp
    libsamplerate
    libsidplayfp
    libsndfile
    libvorbis
    libxml2
    lirc
    mpg123
    neon
    opusfile
    pipewire
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtwayland
    soxr
    wavpack
    libopenmpt
  ];

  mesonFlags = [
    "-Dgtk=false"
  ];

  dontWrapQtApps = true;

  postInstall = ''
    ln -s ${vgmstream.audacious}/lib/audacious/Input/* $out/lib/audacious/Input
  '';

  meta = audacious-bare.meta // {
    description = "Plugins for Audacious music player";
    downloadPage = "https://github.com/audacious-media-player/audacious-plugins";
  };
}
