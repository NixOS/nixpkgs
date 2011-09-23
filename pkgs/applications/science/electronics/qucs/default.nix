{stdenv, fetchurl, qt3, libX11}:

stdenv.mkDerivation rec {
  name = "qucs-0.0.15";

  src = fetchurl {
    url = "mirror://sourceforge/qucs/${name}.tar.gz";
    sha256 = "0ggs2nicj8q270l0rbmzg4jc0d0zdxvfsjh4wgww670ma5855xsp";
  };

  buildInputs = [ qt3 libX11 ];

  meta = {
    description = "Integrated circuit simulator";
    homepage = http://qucs.sourceforge.net;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
