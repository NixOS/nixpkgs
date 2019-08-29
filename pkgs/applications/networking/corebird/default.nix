{ stdenv, fetchFromGitHub, glib, gtk3, json-glib, sqlite, libsoup, gettext, vala_0_40
, meson, ninja, pkgconfig, gnome3, gst_all_1, wrapGAppsHook, gobject-introspection
, glib-networking, python3 }:

stdenv.mkDerivation rec {
  version = "1.7.4";
  name = "corebird-${version}";

  src = fetchFromGitHub {
    owner = "baedert";
    repo = "corebird";
    rev = version;
    sha256 = "0qjffsmg1hm64dgsbkfwzbzy9q4xa1q4fh4h8ni8a2b1p3h80x7n";
  };

  nativeBuildInputs = [
    meson ninja vala_0_40 pkgconfig wrapGAppsHook python3
    gobject-introspection # for setup hook
  ];

  buildInputs = [
    glib gtk3 json-glib sqlite libsoup gettext gnome3.dconf gnome3.gspell glib-networking
  ] ++ (with gst_all_1; [ gstreamer gst-plugins-base gst-plugins-bad (gst-plugins-good.override { gtkSupport = true; }) gst-libav ]);

  postPatch = ''
    chmod +x data/meson_post_install.py # patchShebangs requires executable file
    patchShebangs data/meson_post_install.py
  '';

  meta = {
    description = "Native Gtk+ Twitter client for the Linux desktop";
    longDescription = "Corebird is a modern, easy and fun Twitter client.";
    homepage = https://corebird.baedert.org/;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.jonafato ];
  };
}
