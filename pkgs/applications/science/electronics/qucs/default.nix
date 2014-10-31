{stdenv, fetchurl, flex, bison, qt4, libX11 }:

stdenv.mkDerivation rec {
  name = "qucs-0.0.18";

  src = fetchurl {
    url = "mirror://sourceforge/qucs/${name}.tar.gz";
    sha256 = "3609a18b57485dc9f19886ac6694667f3251702175bd1cbbbea37981b2c482a7";
  };

  QTDIR=qt4;

  buildInputs = [ flex bison qt4 libX11 ];

  meta = {
    description = "Integrated circuit simulator";
    homepage = http://qucs.sourceforge.net;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
