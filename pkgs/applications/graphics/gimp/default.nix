{ stdenv, fetchurl, pkgconfig, gtk, freetype
, fontconfig, libart_lgpl, libtiff, libjpeg, libpng, libexif, zlib, perl
, perlXMLParser, python, pygtk, gettext, xlibs, intltool, babl, gegl
}:

stdenv.mkDerivation rec {
  name = "gimp-2.6.10";
  
  src = fetchurl {
    url = "ftp://ftp.gtk.org/pub/gimp/v2.6/${name}.tar.bz2";
    sha256 = "0cp0abdmqczncy0miazbyd61sjm63r1mhlwsvbz8lb9m7gkkyypg";
  };
  
  buildInputs = [
    pkgconfig gtk freetype fontconfig
    libart_lgpl libtiff libjpeg libpng libexif zlib perl
    perlXMLParser python pygtk gettext intltool babl gegl
  ];

  passthru = { inherit gtk; }; # probably its a good idea to use the same gtk in plugins ?

  configureFlags = [ "--disable-print" ];

  # "screenshot" needs this.
  NIX_LDFLAGS = "-rpath ${xlibs.libX11}/lib";

  meta = {
    description = "The GNU Image Manipulation Program";
    homepage = http://www.gimp.org/;
    license = "GPL";
  };
}
