{ fetchurl, stdenv, pkgconfig, autoconf, automake, clutter, clutter-gst
, gdk_pixbuf, cairo }:

stdenv.mkDerivation rec {
  name = "pinpoint-${version}";
  version = "0.1.4";
  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/pinpoint/0.1/${name}.tar.bz2";
    sha256 = "26df7ba171d13f697c30c272460989b0f1b45e70c797310878a589ed5a6a47de";
  };
  buildInputs = [ pkgconfig autoconf automake clutter clutter-gst gdk_pixbuf
                  cairo ];

  meta = {
    homepage = https://wiki.gnome.org/action/show/Apps/Pinpoint;
    description = "A tool for making hackers do excellent presentations";
    license = stdenv.lib.licenses.lgpl21;
  };
}
