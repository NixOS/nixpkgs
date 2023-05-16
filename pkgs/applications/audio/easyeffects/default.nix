{ lib
, stdenv
, desktop-file-utils
, fetchFromGitHub
, calf
, fftw
, fftwFloat
, fmt_9
, glib
, gsl
, gtk4
, itstool
, libadwaita
, libbs2b
, libebur128
, libsamplerate
, libsigcxx30
, libsndfile
, lilv
, lsp-plugins
, lv2
, mda_lv2
, meson
, ninja
, nlohmann_json
, pipewire
, pkg-config
, rnnoise
, rubberband
<<<<<<< HEAD
=======
, speex
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, speexdsp
, tbb
, wrapGAppsHook4
, zam-plugins
, zita-convolver
<<<<<<< HEAD
, soundtouch
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "easyeffects";
<<<<<<< HEAD
  version = "7.0.5";
=======
  version = "7.0.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "wwmm";
    repo = "easyeffects";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Z/0O8dVZ3J901OdOc1wF1XibNE/33b8oSqY6RKPDfzg=";
=======
    sha256 = "sha256-vHswNRu4JrW95nZaEBs95exUqslO0dyIr41E1gJhHow=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    desktop-file-utils
    itstool
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    fftw
    fftwFloat
    fmt_9
    glib
    gsl
    gtk4
    libadwaita
    libbs2b
    libebur128
    libsamplerate
    libsigcxx30
    libsndfile
    lilv
    lv2
    nlohmann_json
    pipewire
    rnnoise
    rubberband
<<<<<<< HEAD
    soundtouch
=======
    speex
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    speexdsp
    tbb
    zita-convolver
  ];

  preFixup =
    let
      lv2Plugins = [
        calf # compressor exciter, bass enhancer and others
        lsp-plugins # delay, limiter, multiband compressor
        mda_lv2 # loudness
        zam-plugins # maximizer
      ];
      ladspaPlugins = [
        rubberband # pitch shifting
      ];
    in
    ''
      gappsWrapperArgs+=(
        --set LV2_PATH "${lib.makeSearchPath "lib/lv2" lv2Plugins}"
        --set LADSPA_PATH "${lib.makeSearchPath "lib/ladspa" ladspaPlugins}"
      )
    '';

  separateDebugInfo = true;

  meta = with lib; {
    description = "Audio effects for PipeWire applications.";
    homepage = "https://github.com/wwmm/easyeffects";
    license = licenses.gpl3Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    mainProgram = "easyeffects";
=======
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
