{ stdenv, fetchFromGitHub, gdk_pixbuf, scons, pkgconfig, gtk, glib,
  pcre, cfitsio, perl, gob2, vala, libtiff, json_glib }:

stdenv.mkDerivation rec {
  name = "giv-20150811-git";

  src = fetchFromGitHub {
    owner = "dov";
    repo = "giv";
    rev = "64648bfbbf10ec4a9adfbc939c96c7d1dbdce57a";
    sha256 = "1sz2n7jbmg3g97bs613xxjpzqbsl5rvpg6v7g3x3ycyd35r8vsfp";
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
