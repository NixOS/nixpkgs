{ stdenv, fetchurl, pkgconfig, intltool, gtk, alsaLib, libglade }:

stdenv.mkDerivation {
  name = "lingot-0.9.0";

  src = fetchurl {
    url = http://download.savannah.gnu.org/releases/lingot/lingot-0.9.0.tar.gz;
    sha256 = "07z129lp8m4sz608q409wb11c639w7cbn497r7bscgg08p6c07xb";
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
