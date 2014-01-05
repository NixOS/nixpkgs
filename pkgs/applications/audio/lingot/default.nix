{ stdenv, fetchurl, pkgconfig, intltool, gtk, alsaLib, libglade }:

stdenv.mkDerivation {
  name = "lingot-0.9.1";

  src = fetchurl {
    url = mirror://savannah/lingot/lingot-0.9.1.tar.gz;
    sha256 = "0ygras6ndw2fylwxx86ac11pcr2y2bcfvvgiwrh92z6zncx254gc";
  };

  buildInputs = [ pkgconfig intltool gtk alsaLib libglade ];

  configureFlags = "--disable-jack";

  meta = {
    description = "Not a Guitar-Only tuner";
    homepage = http://www.nongnu.org/lingot/;
    license = "GPLv2+";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
