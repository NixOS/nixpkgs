{ stdenv, fetchurl, cmake, qt4, kdelibs, automoc4, phonon, perl
, gettext}:

stdenv.mkDerivation rec {
  name = "rekonq-0.7.0";
  passthru = { inherit stdenv; };

  src = fetchurl {
    url = "mirror://sf/rekonq/${name}.tar.bz2";
    sha256 = "14gi8ic53jkam2v52zp4p965dw6pqhjm3xhqssm5vimx7hp0kc1w";
  };

  buildInputs = [ cmake qt4 kdelibs automoc4 phonon perl gettext ];

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.urkud ];
    description = "KDE Webkit browser";
    homepage = http://rekonq.sourceforge.net;
  };
}
