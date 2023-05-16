<<<<<<< HEAD
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
=======
{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, qttools, wrapQtAppsHook
, alsa-lib, dssi, fluidsynth, ladspaH, lash, libinstpatch, libjack2, liblo
, libsamplerate, libsndfile, lilv, lrdf, lv2, qtsvg, rtaudio, rubberband, sord, serd
}:

stdenv.mkDerivation rec {
  pname = "muse-sequencer";
  version = "3.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "muse-sequencer";
    repo = "muse";
<<<<<<< HEAD
    rev = finalAttrs.version;
    hash = "sha256-JPvoximDL4oKO8reXW7alMegwUyUTSAcdq3ueXeUMMY=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";
=======
    rev = "muse_${builtins.replaceStrings ["."] ["_"] version}";
    sha256 = "1rasp2v1ds2aw296lbf27rzw0l9fjl0cvbvw85d5ycvh6wkm301p";
  };

  sourceRoot = "source/muse3";

  patches = [ ./fix-parallel-building.patch ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  nativeBuildInputs = [ cmake pkg-config qttools wrapQtAppsHook ];

  buildInputs = [
<<<<<<< HEAD
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
=======
    alsa-lib dssi fluidsynth ladspaH lash libinstpatch libjack2 liblo
    libsamplerate libsndfile lilv lrdf lv2 qtsvg rtaudio rubberband sord
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  env.NIX_CFLAGS_COMPILE = toString [ "-I${lib.getDev serd}/include/serd-0" ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://muse-sequencer.github.io/";
    description = "MIDI/Audio sequencer with recording and editing capabilities";
    longDescription = ''
      MusE is a MIDI/Audio sequencer with recording and editing capabilities
      written originally by Werner Schweer now developed and maintained
      by the MusE development team.

      MusE aims to be a complete multitrack virtual studio for Linux,
      it is published under the GNU General Public License.
    '';
<<<<<<< HEAD
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ eclairevoyant orivej ];
    platforms = lib.platforms.linux;
    mainProgram = "muse4";
  };
})
=======
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ orivej ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
