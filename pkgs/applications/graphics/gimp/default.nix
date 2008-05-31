{ stdenv, fetchurl, pkgconfig, gtk, libgtkhtml, freetype
, fontconfig, libart_lgpl, libtiff, libjpeg, libpng, libexif, zlib, perl
, perlXMLParser, python, pygtk, gettext, xlibs
}:

stdenv.mkDerivation {
  name = "gimp-2.4.6";
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/gimp/v2.4/gimp-2.4.6.tar.bz2;
    sha256 = "1shbrrncx99pbn66xpya0a55cv18g4lvl9spc3ry906z1vkzkblr";
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
