{ stdenv, fetchurl, pkgconfig, gtk, libgtkhtml, freetype
, fontconfig, libart_lgpl, libtiff, libjpeg, libpng, libexif, zlib, perl
, perlXMLParser, python, pygtk, gettext, xlibs
}:

stdenv.mkDerivation {
  name = "gimp-2.4.4";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gimp/v2.4/gimp-2.4.4.tar.bz2;
    sha256 = "1mnl30b4p7c2lxi68z3fhwmganhwppyiw7r0m3r90vnakcawfnfh";
  };
  
  buildInputs = [
    pkgconfig gtk libgtkhtml freetype fontconfig
    libart_lgpl libtiff libjpeg libpng libexif zlib perl
    perlXMLParser python pygtk gettext
  ];

  configureFlags = [ "--disable-print" ];

  # "screenshot" needs this.
  NIX_LDFLAGS = "-rpath ${xlibs.libX11}/lib";

  meta = {
    description = "The GNU Image Manipulation Program";
    homepage = http://www.gimp.org/;
    license = "GPL";
  };
}
