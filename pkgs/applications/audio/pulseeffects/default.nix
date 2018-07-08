{ stdenv
, fetchFromGitHub
, meson
, ninja
, pkgconfig
, libxml2
, desktop-file-utils
, wrapGAppsHook
, gst_all_1
, pulseaudio
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
, boost
, calf
, zam-plugins
, rubberband
, mda_lv2
}:

let
  lv2Plugins = [
    calf # limiter, compressor exciter, bass enhancer and others
    mda_lv2 # loudness
  ];
  ladspaPlugins = [
    rubberband # pitch shifting
    zam-plugins # maximizer
  ];
in stdenv.mkDerivation rec {
  name = "pulseeffects-${version}";
  version = "4.1.3";

  src = fetchFromGitHub {
    owner = "wwmm";
    repo = "pulseeffects";
    rev = "v${version}";
    sha256 = "1f89msg8hzaf1pa9w3gaifb88dm0ca2wd81jlz3vr98hm7kxd85k";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    libxml2
    desktop-file-utils
    wrapGAppsHook
  ];

  buildInputs = [
    pulseaudio
    glib
    glibmm
    gtk3
    gtkmm3
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    lilv lv2 serd sord sratom
    libbs2b
    boost
  ];

  postPatch = ''
    chmod +x meson_post_install.py
    patchShebangs meson_post_install.py
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --set LV2_PATH "${stdenv.lib.makeSearchPath "lib/lv2" lv2Plugins}"
      --set LADSPA_PATH "${stdenv.lib.makeSearchPath "lib/ladspa" ladspaPlugins}"
    )
  '';

  meta = with stdenv.lib; {
    description = "Limiter, compressor, reverberation, equalizer and auto volume effects for Pulseaudio applications";
    homepage = https://github.com/wwmm/pulseeffects;
    license = licenses.gpl3;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
