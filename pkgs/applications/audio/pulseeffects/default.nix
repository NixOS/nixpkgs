{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, meson
, ninja
, pkg-config
, itstool
, python3
, libxml2
, desktop-file-utils
, wrapGAppsHook
, gst_all_1
, pipewire
, gtk3
, glib
, glibmm
, gtkmm3
, lilv
, lv2
, serd
, sord
, sratom
, libbs2b
, libsamplerate
, libsndfile
, libebur128
, rnnoise
, boost
, dbus
, fftwFloat
, calf
, zita-convolver
, zam-plugins
, rubberband
, lsp-plugins
}:

let
  lv2Plugins = [
    calf # limiter, compressor exciter, bass enhancer and others
    lsp-plugins # delay
  ];
  ladspaPlugins = [
    rubberband # pitch shifting
    zam-plugins # maximizer
  ];
in stdenv.mkDerivation rec {
  pname = "pulseeffects";
  version = "5.0.3";

  src = fetchFromGitHub {
    owner = "wwmm";
    repo = "pulseeffects";
    rev = "v${version}";
    sha256 = "1dicvq17vajk3vr4g1y80599ahkw0dp5ynlany1cfljfjz40s8sx";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    libxml2
    itstool
    python3
    desktop-file-utils
    wrapGAppsHook
  ];

  buildInputs = [
    pipewire
    glib
    glibmm
    gtk3
    gtkmm3
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base # gst-fft
    gst_all_1.gst-plugins-good # spectrum plugin
    gst_all_1.gst-plugins-bad
    lilv lv2 serd sord sratom
    libbs2b
    libebur128
    libsamplerate
    libsndfile
    rnnoise
    boost
    dbus
    fftwFloat
    zita-convolver
  ];

  patches = [
    (fetchpatch {
      # Fix build failure.
      # https://github.com/wwmm/pulseeffects/pull/934
      url = "https://github.com/wwmm/pulseeffects/commit/ab7354a6850d23840b4c9af212dbebf4f31a562f.patch";
      sha256 = "1hd05xn6sp0xs632mqgwk19hl40kh2f69mx5mgzahysrj057w22c";
    })
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set LV2_PATH "${lib.makeSearchPath "lib/lv2" lv2Plugins}"
      --set LADSPA_PATH "${lib.makeSearchPath "lib/ladspa" ladspaPlugins}"
    )
  '';

  # Meson is no longer able to pick up Boost automatically.
  # https://github.com/NixOS/nixpkgs/issues/86131
  BOOST_INCLUDEDIR = "${lib.getDev boost}/include";
  BOOST_LIBRARYDIR = "${lib.getLib boost}/lib";

  separateDebugInfo = true;

  meta = with lib; {
    description = "Limiter, compressor, reverberation, equalizer and auto volume effects for Pulseaudio applications";
    homepage = "https://github.com/wwmm/pulseeffects";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
    badPlatforms = [ "aarch64-linux" ];
  };
}
