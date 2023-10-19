{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, qttools
, wrapQtAppsHook
, alsa-lib
, dssi
, fluidsynth
, ladspaH
, lash
, libinstpatch
, libjack2
, liblo
, libsamplerate
, libsndfile
, lilv
, lrdf
, lv2
, qtsvg
, rtaudio
, rubberband
, sord
, serd
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "muse-sequencer";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "muse-sequencer";
    repo = "muse";
    rev = finalAttrs.version;
    hash = "sha256-JPvoximDL4oKO8reXW7alMegwUyUTSAcdq3ueXeUMMY=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  nativeBuildInputs = [ cmake pkg-config qttools wrapQtAppsHook ];

  buildInputs = [
    alsa-lib
    dssi
    fluidsynth
    ladspaH
    lash
    libinstpatch
    libjack2
    liblo
    libsamplerate
    libsndfile
    lilv
    lrdf
    lv2
    qtsvg
    rtaudio
    rubberband
    sord
  ];

  env.NIX_CFLAGS_COMPILE = toString [ "-I${lib.getDev serd}/include/serd-0" ];

  meta = {
    homepage = "https://muse-sequencer.github.io/";
    description = "MIDI/Audio sequencer with recording and editing capabilities";
    longDescription = ''
      MusE is a MIDI/Audio sequencer with recording and editing capabilities
      written originally by Werner Schweer now developed and maintained
      by the MusE development team.

      MusE aims to be a complete multitrack virtual studio for Linux,
      it is published under the GNU General Public License.
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ eclairevoyant orivej ];
    platforms = lib.platforms.linux;
    mainProgram = "muse4";
  };
})
