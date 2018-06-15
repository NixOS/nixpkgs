{ fetchurl, stdenv, pkgconfig, autoconf, automake, clutter, clutter-gst
, gdk_pixbuf, cairo, clutter-gtk }:

stdenv.mkDerivation rec {
  name = "pinpoint-${version}";
  version = "0.1.8";
  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/pinpoint/0.1/${name}.tar.xz";
    sha256 = "1jp8chr9vjlpb5lybwp5cg6g90ak5jdzz9baiqkbg0anlg8ps82s";
  };
  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ autoconf automake clutter clutter-gst gdk_pixbuf
                  cairo clutter-gtk ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Apps/Pinpoint;
    description = "A tool for making hackers do excellent presentations";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
