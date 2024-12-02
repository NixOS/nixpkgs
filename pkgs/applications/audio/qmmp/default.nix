{ lib, stdenv, fetchurl, cmake, pkg-config
, qtbase, qttools, qtmultimedia, wrapQtAppsHook
# transports
, curl, libmms
# input plugins
, libmad, taglib, libvorbis, libogg, flac, libmpcdec, libmodplug, libsndfile
, libcdio, cdparanoia, libcddb, faad2, ffmpeg, wildmidi, libbs2b, game-music-emu
, libarchive, opusfile, soxr, wavpack, libxmp, libsidplayfp
# output plugins
, alsa-lib, libpulseaudio, pipewire, libjack2
# effect plugins
, libsamplerate
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

stdenv.mkDerivation rec {
  pname = "qmmp";
  version = "2.1.8";

  src = fetchurl {
    url = "https://qmmp.ylsoftware.com/files/qmmp/2.1/${pname}-${version}.tar.bz2";
    hash = "sha256-hGphQ8epqym47C9doiSOQd3yc28XwV2UsNc7ivhaae4=";
  };

  nativeBuildInputs = [ cmake pkg-config wrapQtAppsHook ];

  buildInputs =
    [ # basic requirements
      qtbase qttools qtmultimedia
      # transports
      curl libmms
      # input plugins
      libmad taglib libvorbis libogg flac libmpcdec libmodplug libsndfile
      libcdio cdparanoia libcddb faad2 ffmpeg wildmidi libbs2b game-music-emu
      libarchive opusfile soxr wavpack libxmp libsidplayfp
      # output plugins
      alsa-lib libpulseaudio pipewire libjack2
      # effect plugins
      libsamplerate
    ];

  meta = with lib; {
    description = "Qt-based audio player that looks like Winamp";
    mainProgram = "qmmp";
    homepage = "https://qmmp.ylsoftware.com/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
