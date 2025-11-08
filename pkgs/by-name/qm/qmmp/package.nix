{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  qt6,
  # transports
  curl,
  libmms,
  # input plugins
  libmad,
  taglib,
  libvorbis,
  libogg,
  flac,
  libmpcdec,
  libmodplug,
  libsndfile,
  libcdio,
  cdparanoia,
  libcddb,
  faad2,
  ffmpeg,
  wildmidi,
  libbs2b,
  game-music-emu,
  libarchive,
  opusfile,
  soxr,
  wavpack,
  libxmp,
  libsidplayfp,
  # output plugins
  alsa-lib,
  libpulseaudio,
  pipewire,
  libjack2,
  # effect plugins
  libsamplerate,
}:

# Additional plugins that can be added:
#  ProjectM visualization plugin

# To make MIDI work we must tell Qmmp what instrument configuration to use (and
# this can unfortunately not be set at configure time):
# Go to settings (ctrl-p), navigate to the WildMidi plugin and click on
# Preferences. In the instrument configuration field, type the path to
# /nix/store/*wildmidi*/etc/wildmidi.cfg (or your own custom cfg file).

# Qmmp installs working .desktop file(s) all by itself, so we don't need to
# handle that.

stdenv.mkDerivation (finalAttrs: {
  pname = "qmmp";
  version = "2.3.0";

  src = fetchurl {
    url = "https://qmmp.ylsoftware.com/files/qmmp/2.3/qmmp-${finalAttrs.version}.tar.bz2";
    hash = "sha256-AcPjA2fIhReM0RVZTSD2lKR6NS/X5l/PVyLhKsgzMGM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    # basic requirements
    qt6.qtbase
    qt6.qttools
    qt6.qtmultimedia
    # transports
    curl
    libmms
    # input plugins
    libmad
    taglib
    libvorbis
    libogg
    flac
    libmpcdec
    libmodplug
    libsndfile
    libcdio
    cdparanoia
    libcddb
    faad2
    ffmpeg
    wildmidi
    libbs2b
    game-music-emu
    libarchive
    opusfile
    soxr
    wavpack
    libxmp
    libsidplayfp
    # output plugins
    alsa-lib
    libpulseaudio
    pipewire
    libjack2
    # effect plugins
    libsamplerate
  ];

  meta = {
    description = "Qt-based audio player that looks like Winamp";
    mainProgram = "qmmp";
    homepage = "https://qmmp.ylsoftware.com/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.bjornfor ];
  };
})
