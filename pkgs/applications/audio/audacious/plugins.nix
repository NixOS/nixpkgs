{ stdenv
, fetchurl
, alsa-lib
, audacious
, curl
, faad2
, ffmpeg
, flac
, fluidsynth
, gdk-pixbuf
, gettext
, lame
, libbs2b
, libcddb
, libcdio
, libcdio-paranoia
, libcue
, libjack2
, libmad
, libmms
, libmodplug
, libmowgli
, libnotify
, libogg
, libopenmpt
, libpulseaudio
, libsamplerate
, libsidplayfp
, libsndfile
, libvorbis
, libxml2
, lirc
, meson
, mpg123
, neon
, ninja
, pkg-config
, qtbase
, qtmultimedia
, qtx11extras
, soxr
, wavpack
}:

stdenv.mkDerivation rec {
  pname = "audacious-plugins";
  version = "4.2";

  src = fetchurl {
    url = "http://distfiles.audacious-media-player.org/audacious-plugins-${version}.tar.bz2";
    sha256 = "sha256-b6D2nDoQQeuHfDcQlROrSioKVqd9nowToVgc8UOaQX8=";
  };

  patches = [ ./0001-Set-plugindir-to-PREFIX-lib-audacious.patch ];

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    audacious
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
    libsamplerate
    libsidplayfp
    libsndfile
    libvorbis
    libxml2
    lirc
    mpg123
    neon
    qtbase
    qtmultimedia
    qtx11extras
    soxr
    wavpack
    libopenmpt
  ];

  mesonFlags = [
    "-Dgtk=false"
  ];

  dontWrapQtApps = true;

  meta = audacious.meta // {
    description = "Plugins for Audacious music player";
  };
}
