{stdenv, fetchurl, cmake, qt4, perl, gettext, kdelibs, kdebase, automoc4, phonon}:

stdenv.mkDerivation rec {
  name = "krusader-2.2.0-beta1";
  src = fetchurl {
    url = "mirror://sourceforge/krusader/${name}.tar.bz2";
    sha256 = "0rbk0hw8p1bb03w74gspljbzhvpbs3dcr6ckp38gh5r80mcmqfbs";
  };
  buildInputs = [ cmake qt4 perl gettext kdelibs automoc4 phonon kdebase ];
  meta = {
    description = "Norton/Total Commander clone for KDE";
    license = "GPL";
    homepage = http://www.krusader.org;
    maintainers = with stdenv.lib.maintainers; [ sander urkud ];
  };
}
