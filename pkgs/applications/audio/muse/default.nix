{ stdenv, fetchFromGitHub, cmake, pkgconfig, qttools, wrapQtAppsHook
, alsaLib, dssi, fluidsynth, ladspaH, lash, libinstpatch, libjack2, liblo
, libsamplerate, libsndfile, lilv, lrdf, lv2, qtsvg, rtaudio, rubberband, sord
}:

stdenv.mkDerivation rec {
  pname = "muse-sequencer";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "muse-sequencer";
    repo = "muse";
    rev = "muse_${builtins.replaceStrings ["."] ["_"] version}";
    sha256 = "1rasp2v1ds2aw296lbf27rzw0l9fjl0cvbvw85d5ycvh6wkm301p";
  };

  sourceRoot = "source/muse3";

  prePatch = ''
    chmod u+w $NIX_BUILD_TOP
  '';

  patches = [ ./fix-parallel-building.patch ];

  nativeBuildInputs = [ cmake pkgconfig qttools wrapQtAppsHook ];

  buildInputs = [
    alsaLib dssi fluidsynth ladspaH lash libinstpatch libjack2 liblo
    libsamplerate libsndfile lilv lrdf lv2 qtsvg rtaudio rubberband sord
  ];

  meta = with stdenv.lib; {
    homepage = "https://muse-sequencer.github.io/";
    description = "MIDI/Audio sequencer with recording and editing capabilities";
    longDescription = ''
      MusE is a MIDI/Audio sequencer with recording and editing capabilities
      written originally by Werner Schweer now developed and maintained
      by the MusE development team.

      MusE aims to be a complete multitrack virtual studio for Linux,
      it is published under the GNU General Public License.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ orivej ];
  };
}
