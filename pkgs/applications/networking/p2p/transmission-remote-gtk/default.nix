{ stdenv, fetchurl, pkgconfig, intltool, gtk, json_glib, curl }:


stdenv.mkDerivation rec {
  name = "transmission-remote-gtk-1.0.1";

  src = fetchurl {
    url = "http://transmission-remote-gtk.googlecode.com/files/${name}.tar.gz";
    sha256 = "b1ae032dd52b2d7975656913e4fe39e7f74d29ef8138292d8b82318ff9afed6f";
  };

  buildInputs = [ pkgconfig intltool gtk json_glib curl ];

  meta = {
   description = "GTK remote control for the Transmission BitTorrent client";
  };
}
