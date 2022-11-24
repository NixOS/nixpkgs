{ lib, mkDerivation, fetchurl, cmake, pkg-config
, qtbase, qttools, qtmultimedia, qtx11extras
# transports
, curl, libmms
# input plugins
, libmad, taglib, libvorbis, libogg, flac, libmpcdec, libmodplug, libsndfile
, libcdio, cdparanoia, libcddb, faad2, ffmpeg, wildmidi
# output plugins
, alsa-lib, libpulseaudio
# effect plugins
, libsamplerate
}:

# Additional plugins that can be added:
#  wavpack (https://www.wavpack.com/)
#  gme (Game music support)
#  Ogg Opus support
#  BS2B effect plugin (http://bs2b.sourceforge.net/)
#  JACK audio support
#  ProjectM visualization plugin

# To make MIDI work we must tell Qmmp what instrument configuration to use (and
# this can unfortunately not be set at configure time):
# Go to settings (ctrl-p), navigate to the WildMidi plugin and click on
# Preferences. In the instrument configuration field, type the path to
# /nix/store/*wildmidi*/etc/wildmidi.cfg (or your own custom cfg file).

# Qmmp installs working .desktop file(s) all by itself, so we don't need to
# handle that.

mkDerivation rec {
  pname = "qmmp";
  version = "1.4.4";

  src = fetchurl {
    url = "https://qmmp.ylsoftware.com/files/${pname}-${version}.tar.bz2";
    sha256 = "sha256-sZRZVhCf2ceETuV4AULA0kVkuIMn3C+aYdKThqvPnVQ=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs =
    [ # basic requirements
      qtbase qttools qtmultimedia qtx11extras
      # transports
      curl libmms
      # input plugins
      libmad taglib libvorbis libogg flac libmpcdec libmodplug libsndfile
      libcdio cdparanoia libcddb faad2 ffmpeg wildmidi
      # output plugins
      alsa-lib libpulseaudio
      # effect plugins
      libsamplerate
    ];

  meta = with lib; {
    description = "Qt-based audio player that looks like Winamp";
    homepage = "https://qmmp.ylsoftware.com/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
