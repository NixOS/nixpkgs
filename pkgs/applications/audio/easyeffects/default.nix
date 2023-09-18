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
, speexdsp
, soundtouch
, tbb
, wrapGAppsHook4
, zam-plugins
, zita-convolver
}:

stdenv.mkDerivation rec {
  pname = "easyeffects";
  version = "7.1.0";

  src = fetchFromGitHub {
    owner = "wwmm";
    repo = "easyeffects";
    rev = "v${version}";
    hash = "sha256-TuVW2KBJciuFVdduzfFepGOa+UY9+sXRN1gWhfDvXgw=";
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
    soundtouch
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
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    mainProgram = "easyeffects";
  };
}
