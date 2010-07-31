{ stdenv, fetchurl, cmake, qt4, kdelibs, automoc4, phonon, perl
, gtk, gettext, pixman}:

stdenv.mkDerivation rec {
  name = "rekonq-0.5.0";

  src = fetchurl {
    url = "mirror://sf/rekonq/${name}.tar.bz2";
    sha256 = "0qm16ivxlh3pj7v39z3ajf90sgm5q5xq6a8s2x1a0ipsh7fgkp58";
  };

  buildInputs = [ cmake qt4 kdelibs automoc4 phonon perl gtk gettext pixman ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.urkud ];
    description = "KDE Webkit browser";
    homepage = http://rekonq.sourceforge.net;
  };
}
