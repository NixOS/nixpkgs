{ stdenv
, fetchFromGitHub
, libjack2
, wrapQtAppsHook
, qtsvg
, qttools
, cmake
, libsndfile
, libsamplerate
, ladspaH
, fluidsynth
, alsaLib
, rtaudio
, lash
, dssi
, liblo
, pkgconfig
}:

stdenv.mkDerivation rec {
  pname = "muse-sequencer";
  version = "3.1.0";

  meta = with stdenv.lib; {
    homepage = "https://www.muse-sequencer.org/";
    description = "MIDI/Audio sequencer with recording and editing capabilities";
    longDescription = ''
      MusE is a MIDI/Audio sequencer with recording and editing capabilities
      written originally by Werner Schweer now developed and maintained
      by the MusE development team.

      MusE aims to be a complete multitrack virtual studio for Linux,
      it is published under the GNU General Public License.
    '';
    license = stdenv.lib.licenses.gpl2Plus;
  };

  src =
    fetchFromGitHub {
      owner = "muse-sequencer";
      repo = "muse";
      rev = "muse_${builtins.replaceStrings ["."] ["_"] version}";
      sha256 = "08k25652w88xf2i79lw305x1phpk7idrww9jkqwcs8q6wzgmz8aq";
    };


  nativeBuildInputs = [
    pkgconfig
    wrapQtAppsHook
    qttools
    cmake
  ];

  buildInputs = [
    libjack2
    qtsvg
    libsndfile
    libsamplerate
    ladspaH
    fluidsynth
    alsaLib
    rtaudio
    lash
    dssi
    liblo
  ];

  sourceRoot = "source/muse3";
}
