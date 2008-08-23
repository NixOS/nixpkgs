{ stdenv, fetchurl, pkgconfig, gtk, libgtkhtml, freetype
, fontconfig, libart_lgpl, libtiff, libjpeg, libpng, libexif, zlib, perl
, perlXMLParser, python, pygtk, gettext, xlibs
}:

stdenv.mkDerivation {
  name = "gimp-2.4.7";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gimp/v2.4/gimp-2.4.7.tar.bz2;
    sha256 = "1j8904cy5sp021fz7ikh2dxm339a36ihns94qr9i1y7sb3qfx66k";
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
