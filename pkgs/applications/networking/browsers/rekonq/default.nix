{ stdenv, fetchurl, cmake, qt4, kdelibs, automoc4, phonon, perl
, gettext}:

stdenv.mkDerivation rec {
  name = "rekonq-0.6.1";
  passthru = { inherit stdenv; };

  src = fetchurl {
    url = "mirror://sf/rekonq/${name}.tar.bz2";
    sha256 = "1hgy8ph4k4ngdy1kr4w3qwkfdylapsj7rjpk8wxn97yc4qnk57by";
  };

  buildInputs = [ cmake qt4 kdelibs automoc4 phonon perl gettext ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.urkud ];
    description = "KDE Webkit browser";
    homepage = http://rekonq.sourceforge.net;
  };
}
