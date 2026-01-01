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
<<<<<<< HEAD
  libmysofa,
=======
  libportal-qt6,
  libsamplerate,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  wrapGAppsNoGuiHook,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

let
  inherit (qt6)
    qtbase
    qtgraphs
<<<<<<< HEAD
    wrapQtAppsHook
    ;
  inherit (kdePackages)
=======
    qtwebengine
    wrapQtAppsHook
    ;
  inherit (kdePackages)
    appstream-qt
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  version = "8.0.9";
=======
  version = "8.0.5";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "wwmm";
    repo = "easyeffects";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-cFMbeJeEIDP7uiNi+rRKErgHtjP/PbPKASo+M2qogZQ=";
=======
    hash = "sha256-LBF8P512XeawlSgOz6AV03Q3ZGTwn+Gnqwh0xU0WEz4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  patches = [ ./qmlmodule-fix.patch ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    intltool
    ninja
    pkg-config
<<<<<<< HEAD
    wrapGAppsNoGuiHook
    wrapQtAppsHook
  ];

  dontWrapGApps = true;

  buildInputs = [
=======
    wrapQtAppsHook
  ];

  buildInputs = [
    appstream-qt
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    libmysofa
=======
    libportal-qt6
    libsamplerate
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    libsigcxx30
    libsndfile
    lilv
    lv2
    nlohmann_json
    pipewire
    qtbase
    qtgraphs
<<<<<<< HEAD
=======
    qtwebengine
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
        "''${gappsWrapperArgs[@]}"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
    changelog = "https://github.com/wwmm/easyeffects/blob/v${version}/src/contents/docs/community/CHANGELOG.md";
=======
    changelog = "https://github.com/wwmm/easyeffects/blob/v${version}/CHANGELOG.md";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
