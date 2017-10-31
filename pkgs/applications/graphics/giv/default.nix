{ stdenv, fetchFromGitHub, gdk_pixbuf, scons, pkgconfig, gtk2, glib,
  pcre, cfitsio, perl, gob2, vala_0_23, libtiff, json_glib }:

stdenv.mkDerivation rec {
  name = "giv-${version}";
  version = "0.9.26";

  src = fetchFromGitHub {
    owner = "dov";
    repo = "giv";
    rev = "v${version}";
    sha256 = "1sfm8j3hvqij6z3h8xz724d7hjqqbzljl2a6pp4yjpnnrxksnic2";
  };

  hardeningDisable = [ "format" ];

  prePatch = ''
    sed -i s,/usr/bin/perl,${perl}/bin/perl, doc/eperl
    sed -i s,/usr/local,$out, SConstruct 
  '';

  patches = [ ./build.patch ];

  buildPhase = "scons";

  installPhase = "scons install";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gdk_pixbuf gtk2 glib scons pcre cfitsio perl gob2 vala_0_23 libtiff
    json_glib ];

  meta = {
    description = "Cross platform image and hierarchical vector viewer based";
    homepage = http://giv.sourceforge.net/giv/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
