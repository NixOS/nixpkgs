{ stdenv, fetchurl, gdk_pixbuf, scons, pkgconfig, gtk, glib,
  pcre, cfitsio, perl, gob2, vala, libtiff }:

stdenv.mkDerivation rec {
  name = "giv-0.9.20";

  src = fetchurl {
    url = "mirror://sourceforge/giv/${name}.tar.gz";
    sha256 = "09s659vvv26nw9vaw3a766al8yq6np7p0xb4iw907921j6nbqp7z";
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

  buildInputs = [ gdk_pixbuf pkgconfig gtk glib scons pcre cfitsio perl gob2 vala libtiff ];

  meta = {
    description = "Cross platform image and hierarchical vector viewer based";
    homepage = http://giv.sourceforge.net/giv/;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
