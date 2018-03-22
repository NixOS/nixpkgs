{ stdenv, fetchFromGitHub, gtk3, json-glib, sqlite, libsoup, gettext, vala_0_32
, automake, autoconf, libtool, pkgconfig, gnome3, gst_all_1, wrapGAppsHook
, glib-networking }:

stdenv.mkDerivation rec {
  version = "1.7.4";
  name = "corebird-${version}";

  src = fetchFromGitHub {
    owner = "baedert";
    repo = "corebird";
    rev = version;
    sha256 = "0qjffsmg1hm64dgsbkfwzbzy9q4xa1q4fh4h8ni8a2b1p3h80x7n";
  };

  preConfigure = ''
    ./autogen.sh
  '';

  nativeBuildInputs = [ automake autoconf libtool pkgconfig wrapGAppsHook ];

  buildInputs = [
    gtk3 json-glib sqlite libsoup gettext vala_0_32 gnome3.dconf gnome3.gspell glib-networking
  ] ++ (with gst_all_1; [ gstreamer gst-plugins-base gst-plugins-good (gst-plugins-bad.override { gtkSupport = true; }) gst-libav ]);

  meta = {
    description = "Native Gtk+ Twitter client for the Linux desktop";
    longDescription = "Corebird is a modern, easy and fun Twitter client.";
    homepage = http://corebird.baedert.org;
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.jonafato ];
  };
}
