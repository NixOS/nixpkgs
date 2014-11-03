{ stdenv, fetchurl, gdk_pixbuf, scons, pkgconfig, gtk, glib,
  pcre, cfitsio, perl, gob2, vala, libtiff, json_glib }:

stdenv.mkDerivation rec {
  name = "giv-0.9.22";

  src = fetchurl {
    url = "mirror://sourceforge/giv/${name}.tar.gz";
    sha256 = "1q0806b66ajppxbv1i71wx5d3ydc1h3hsz23m6g4g80dhiai7dly";
  };

  # It built code to be put in a shared object without -fPIC
  NIX_CFLAGS_COMPILE = "-fPIC";

  prePatch = ''
    sed -i s,/usr/bin/perl,${perl}/bin/perl, doc/eperl
    sed -i s,/usr/local,$out, SConstruct 
  '';

  patches = [ ./build.patch ];

  buildPhase = "scons";

  installPhase = "scons install";

  buildInputs = [ gdk_pixbuf pkgconfig gtk glib scons pcre cfitsio perl gob2 vala libtiff
    json_glib ];

  meta = {
    description = "Cross platform image and hierarchical vector viewer based";
    homepage = http://giv.sourceforge.net/giv/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
