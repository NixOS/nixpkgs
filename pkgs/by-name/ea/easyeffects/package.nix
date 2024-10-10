{
  lib,
  stdenv,
  fetchFromGitHub,
  appstream-glib,
  calf,
  deepfilternet,
  desktop-file-utils,
  fftw,
  fftwFloat,
  fmt_9,
  glib,
  gsl,
  gtk4,
  itstool,
  ladspaH,
  libadwaita,
  libbs2b,
  libebur128,
  libportal-gtk4,
  libsamplerate,
  libsigcxx30,
  libsndfile,
  lilv,
  lsp-plugins,
  lv2,
  mda_lv2,
  meson,
  ninja,
  nix-update-script,
  nlohmann_json,
  pipewire,
  pkg-config,
  rnnoise,
  rubberband,
  soundtouch,
  speexdsp,
  tbb,
  wrapGAppsHook4,
  zam-plugins,
  zita-convolver,
}:

let
  # Fix crashes with speexdsp effects
  speexdsp' = speexdsp.override { withFftw3 = false; };
in
stdenv.mkDerivation rec {
  pname = "easyeffects";
  version = "7.1.9";

  src = fetchFromGitHub {
    owner = "wwmm";
    repo = "easyeffects";
    rev = "refs/tags/v${version}";
    hash = "sha256-It+kldlhThWF9y/rTgKt9QlIouH1cQcCtSHQTsaGjfo=";
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
    appstream-glib
    deepfilternet
    fftw
    fftwFloat
    fmt_9
    glib
    gsl
    gtk4
    ladspaH
    libadwaita
    libbs2b
    libebur128
    libportal-gtk4
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
    speexdsp'
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
        deepfilternet # deep noise remover
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

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Audio effects for PipeWire applications";
    homepage = "https://github.com/wwmm/easyeffects";
    changelog = "https://github.com/wwmm/easyeffects/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ getchoo ];
    mainProgram = "easyeffects";
    platforms = lib.platforms.linux;
  };
}
