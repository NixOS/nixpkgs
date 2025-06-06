{ stdenv
, fetchFromGitHub
, alsa-lib
, audacious
, curl
, faad2
, ffmpeg
, flac
, fluidsynth
, gdk-pixbuf
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
, opusfile
, pipewire
, qtbase
, qtmultimedia
, qtwayland
, soxr
, vgmstream
, wavpack
}:

stdenv.mkDerivation rec {
  pname = "audacious-plugins";
  version = "4.4";

  src = fetchFromGitHub {
    owner = "audacious-media-player";
    repo = "audacious-plugins";
    rev = "${pname}-${version}";
    hash = "sha256-J9jgBl8J4W9Yvrlg1KlzYgGTmdxUZM9L11rCftKFSlE=";
  };

  patches = [ ./0001-Set-plugindir-to-PREFIX-lib-audacious.patch ];

  nativeBuildInputs = [
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
    opusfile
    pipewire
    qtbase
    qtmultimedia
    qtwayland
    soxr
    wavpack
    libopenmpt
  ];

  mesonFlags = [
    "-Dgtk=false"
  ];

  dontWrapQtApps = true;

  postInstall = ''
    ln -s ${vgmstream.override { buildAudaciousPlugin = true; }}/lib/audacious/Input/* $out/lib/audacious/Input
  '';

  meta = audacious.meta // {
    description = "Plugins for Audacious music player";
    downloadPage = "https://github.com/audacious-media-player/audacious-plugins";
  };
}
