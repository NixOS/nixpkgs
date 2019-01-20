{ stdenv
, fetchFromGitHub
, meson
, ninja
, pkgconfig
, itstool
, python3
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
, libsamplerate
, libsndfile
, libebur128
, boost
, dbus
, fftwFloat
, calf
, zita-convolver
, zam-plugins
, rubberband
, mda_lv2
, hicolor-icon-theme
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
  pname = "pulseeffects";
  version = "4.4.6";

  src = fetchFromGitHub {
    owner = "wwmm";
    repo = "pulseeffects";
    rev = "v${version}";
    sha256 = "0zvcj2qliz2rlcz59ag4ljrs78qb7kpyaph16qvi07ij7c5bm333";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    libxml2
    itstool
    python3
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
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    lilv lv2 serd sord sratom
    libbs2b
    libebur128
    libsamplerate
    libsndfile
    boost
    dbus
    fftwFloat
    zita-convolver
    hicolor-icon-theme
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
