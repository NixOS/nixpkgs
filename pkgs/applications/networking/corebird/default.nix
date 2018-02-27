{ stdenv, fetchFromGitHub, gtk3, json-glib, sqlite, libsoup, gettext, vala_0_32
, automake, autoconf, libtool, pkgconfig, gnome3, gst_all_1, wrapGAppsHook
, glib-networking }:

stdenv.mkDerivation rec {
  version = "1.7.3";
  name = "corebird-${version}";

  src = fetchFromGitHub {
    owner = "baedert";
    repo = "corebird";
    rev = version;
    sha256 = "1xay22v5j239ppl6ydbj842zpm5v2mg5mcgpy5cjrhhmnbg79fgk";
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
