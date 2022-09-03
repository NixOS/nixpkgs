{ lib
, stdenv
, desktop-file-utils
, fetchFromGitHub
, calf
, fftwFloat
, fmt_8
, glib
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
, tbb
, wrapGAppsHook4
, zam-plugins
, zita-convolver
}:

stdenv.mkDerivation rec {
  pname = "easyeffects";
  version = "6.3.0";

  src = fetchFromGitHub {
    owner = "wwmm";
    repo = "easyeffects";
    rev = "v${version}";
    sha256 = "sha256-OLxuE1jiALuKlC9U9esVlhaMBEaoZyNae8OO8upE4ZM=";
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
    fftwFloat
    fmt_8
    glib
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
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
    badPlatforms = [ "aarch64-linux" ];
  };
}
