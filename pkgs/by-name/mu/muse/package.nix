{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  pkg-config,
  alsa-lib,
  dssi,
  fluidsynth,
  ladspaH,
  lash,
  libinstpatch,
  libjack2,
  liblo,
  libsamplerate,
  libsndfile,
  lilv,
  lrdf,
  lv2,
  rtaudio,
  rubberband,
  sord,
  serd,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "muse-sequencer";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "muse-sequencer";
    repo = "muse";
    tag = finalAttrs.version;
    hash = "sha256-LxibuqopMHuKEfTWXSEXc1g3wTm2F3NQRiV71FHvaY0=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
  ];

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
    libsForQt5.qtsvg
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
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "muse4";
  };
})
