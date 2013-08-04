{ stdenv, fetchurl, pkgconfig, gtk, freetype
, fontconfig, libart_lgpl, libtiff, libjpeg, libpng, libexif, zlib, perl
, perlXMLParser, python, pygtk, gettext, xlibs, intltool, babl_0_0_22, gegl_0_0_22
}:

stdenv.mkDerivation rec {
  name = "gimp-2.6.12";

  src = fetchurl {
    url = "ftp://ftp.gtk.org/pub/gimp/v2.6/${name}.tar.bz2";
    sha256 = "0qpcgaa4pdqqhyyy8vjvzfflxgsrrs25zk79gixzlnbzq3qwjlym";
  };

  buildInputs = [
    pkgconfig gtk freetype fontconfig
    libart_lgpl libtiff libjpeg libpng libexif zlib perl
    perlXMLParser python pygtk gettext intltool babl_0_0_22 gegl_0_0_22
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
