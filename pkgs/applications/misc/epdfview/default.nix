{ stdenv, fetchurl, pkgconfig, gtk, poppler }:
stdenv.mkDerivation rec {
  name = "epdfview-0.1.7";
  src = fetchurl {
    url = "http://trac.emma-soft.com/epdfview/chrome/site/releases/${name}.tar.bz2";
    sha256 = "1s2af09ij5jjqryv4dl10flsdk5p953qp94dymn93fnl93rv1yqa";
  };
  buildInputs = [ pkgconfig gtk poppler ];
  meta = {
    homepage = http://trac.emma-soft.com/epdfview/;
    description = "A lightweight PDF document viewer using Poppler and GTK+";
    longDescription = ''
        ePDFView is a free lightweight PDF document viewer using Poppler and
        GTK+ libraries. The aim of ePDFView is to make a simple PDF document
        viewer, in the lines of Evince but without using the Gnome libraries. 
    '';
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [ astsmtl ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
