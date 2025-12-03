{
  lib,
  stdenv,
  calf,
  cmake,
  deepfilternet,
  fetchFromGitHub,
  fftw,
  fftwFloat,
  glib,
  gsl,
  intltool,
  kdePackages,
  ladspaH,
  libbs2b,
  libebur128,
  libportal-qt6,
  libsamplerate,
  libsigcxx30,
  libsndfile,
  lilv,
  lsp-plugins,
  lv2,
  mda_lv2,
  ninja,
  nix-update-script,
  nlohmann_json,
  pipewire,
  pkg-config,
  qt6,
  rnnoise,
  rubberband,
  soundtouch,
  speexdsp,
  onetbb,
  webrtc-audio-processing,
  zam-plugins,
  zita-convolver,
}:

let
  inherit (qt6)
    qtbase
    qtgraphs
    qtwebengine
    wrapQtAppsHook
    ;
  inherit (kdePackages)
    appstream-qt
    breeze
    breeze-icons
    extra-cmake-modules
    kcolorscheme
    kconfigwidgets
    kiconthemes
    kirigami
    kirigami-addons
    qqc2-desktop-style
    ;
in

stdenv.mkDerivation rec {
  pname = "easyeffects";
  version = "8.0.6";

  src = fetchFromGitHub {
    owner = "wwmm";
    repo = "easyeffects";
    tag = "v${version}";
    hash = "sha256-5UPwCdpFU1SiD9nlQd99lAK7QdC9jcizj5X3BhBYJ4U=";
  };

  patches = [ ./qmlmodule-fix.patch ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    intltool
    ninja
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    appstream-qt
    breeze
    breeze-icons
    deepfilternet
    fftw
    fftwFloat
    glib
    gsl
    kcolorscheme
    kconfigwidgets
    kiconthemes
    kirigami
    kirigami-addons
    ladspaH
    qqc2-desktop-style
    libbs2b
    libebur128
    libportal-qt6
    libsamplerate
    libsigcxx30
    libsndfile
    lilv
    lv2
    nlohmann_json
    pipewire
    qtbase
    qtgraphs
    qtwebengine
    rnnoise
    rubberband
    soundtouch
    speexdsp
    onetbb
    webrtc-audio-processing
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
        deepfilternet # deep noise remover
        rubberband # pitch shifting
      ];
    in
    ''
      qtWrapperArgs+=(
        --set LV2_PATH "${lib.makeSearchPath "lib/lv2" lv2Plugins}"
        --set LADSPA_PATH "${lib.makeSearchPath "lib/ladspa" ladspaPlugins}"
      )
    '';

  separateDebugInfo = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Audio effects for PipeWire applications";
    homepage = "https://github.com/wwmm/easyeffects";
    changelog = "https://github.com/wwmm/easyeffects/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      getchoo
      aleksana
      Gliczy
    ];
    mainProgram = "easyeffects";
    platforms = lib.platforms.linux;
  };
}
