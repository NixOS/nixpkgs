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
  libmysofa,
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
  wrapGAppsNoGuiHook,
}:

let
  inherit (qt6)
    qtbase
    qtgraphs
    wrapQtAppsHook
    ;
  inherit (kdePackages)
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

stdenv.mkDerivation (finalAttrs: {
  pname = "easyeffects";
  version = "8.0.9";

  src = fetchFromGitHub {
    owner = "wwmm";
    repo = "easyeffects";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cFMbeJeEIDP7uiNi+rRKErgHtjP/PbPKASo+M2qogZQ=";
  };

  patches = [ ./qmlmodule-fix.patch ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    intltool
    ninja
    pkg-config
    wrapGAppsNoGuiHook
    wrapQtAppsHook
  ];

  dontWrapGApps = true;

  buildInputs = [
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
    libmysofa
    libsigcxx30
    libsndfile
    lilv
    lv2
    nlohmann_json
    pipewire
    qtbase
    qtgraphs
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
        "''${gappsWrapperArgs[@]}"
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
    changelog = "https://github.com/wwmm/easyeffects/blob/v${finalAttrs.version}/src/contents/docs/community/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      getchoo
      aleksana
      Gliczy
    ];
    mainProgram = "easyeffects";
    platforms = lib.platforms.linux;
  };
})
