{ lib
, stdenv
, desktop-file-utils
, fetchFromGitHub
, calf
, fftwFloat
, glib
, glibmm
, gtk4
, gtkmm4
, itstool
, libbs2b
, libebur128
, libsamplerate
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
, python3
, rnnoise
, rubberband
, speexdsp
, wrapGAppsHook4
, zam-plugins
, zita-convolver
}:

stdenv.mkDerivation rec {
  pname = "easyeffects";
  version = "6.0.3";

  src = fetchFromGitHub {
    owner = "wwmm";
    repo = "easyeffects";
    rev = "v${version}";
    sha256 = "sha256-GzqPC/m/HMthLMamhJ4EXX6fxZYscdX1QmXgqHOPEcg=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    itstool
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook4
  ];

  buildInputs = [
    fftwFloat
    glib
    glibmm
    gtk4
    gtkmm4
    libbs2b
    libebur128
    libsamplerate
    libsndfile
    lilv
    lv2
    nlohmann_json
    pipewire
    rnnoise
    rubberband
    speexdsp
    zita-convolver
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
    # https://github.com/wwmm/easyeffects/pull/1205
    substituteInPlace meson_post_install.py --replace "gtk-update-icon-cache" "gtk4-update-icon-cache"
  '';

  preFixup =
    let
      lv2Plugins = [
        calf # limiter, compressor exciter, bass enhancer and others
        lsp-plugins # delay
        mda_lv2 # loudness
      ];
      ladspaPlugins = [
        rubberband # pitch shifting
        zam-plugins # maximizer
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
