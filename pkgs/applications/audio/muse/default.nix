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

stdenv.mkDerivation {
  pname = "muse-sequencer";
  version = "3.1pre1";

  meta = with stdenv.lib; {
    homepage = http://www.muse-sequencer.org;
    description = "MIDI/Audio sequencer with recording and editing capabilities";
    longDescription = ''
      MusE is a MIDI/Audio sequencer with recording and editing capabilities
      written originally by Werner Schweer now developed and maintained
      by the MusE development team.

      MusE aims to be a complete multitrack virtual studio for Linux,
      it is published under the GNU General Public License.
    '';
    license = stdenv.lib.licenses.gpl2;
  };

  src =
    fetchFromGitHub {
      owner = "muse-sequencer";
      repo = "muse";
      rev = "2167ae053c16a633d8377acdb1debaac10932838";
      sha256 = "0rsdx8lvcbz5bapnjvypw8h8bq587s9z8cf2znqrk6ah38s6fsrf";
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
