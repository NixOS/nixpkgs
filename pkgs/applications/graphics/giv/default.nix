{ stdenv, fetchFromGitHub, gdk_pixbuf, scons, pkgconfig, gtk2, glib,
  pcre, cfitsio, perl, gob2, vala, libtiff, json-glib }:

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

  nativeBuildInputs = [ scons pkgconfig vala perl gob2 ];
  buildInputs = [ gdk_pixbuf gtk2 glib pcre cfitsio libtiff json-glib ];

  meta = with stdenv.lib; {
    description = "Cross platform image and hierarchical vector viewer based";
    homepage = http://giv.sourceforge.net/giv/;
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ viric ];
    platforms = with platforms; linux;
  };
}
