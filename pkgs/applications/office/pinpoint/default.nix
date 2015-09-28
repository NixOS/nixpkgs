{ fetchurl, stdenv, pkgconfig, autoconf, automake, clutter, clutter-gst
, gdk_pixbuf, cairo }:

stdenv.mkDerivation rec {
  name = "pinpoint-${version}";
  version = "0.1.6";
  src = fetchurl {
    url = "http://ftp.gnome.org/pub/GNOME/sources/pinpoint/0.1/${name}.tar.xz";
    sha256 = "0jzkf74w75paflnvsil2y6qsyaqgxf6akz97176xdg6qri4nwal1";
  };
  buildInputs = [ pkgconfig autoconf automake clutter clutter-gst gdk_pixbuf
                  cairo ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/action/show/Apps/Pinpoint;
    description = "A tool for making hackers do excellent presentations";
    license = licenses.lgpl21;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
