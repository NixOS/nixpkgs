{stdenv, fetchurl, gettext, kdelibs, kde_baseapps}:

stdenv.mkDerivation rec {
  name = "krusader-2.4.0-beta1";
  src = fetchurl {
    url = "mirror://sourceforge/krusader/${name}.tar.bz2";
    sha256 = "1q1m4cjzz2m41pdpxnwrsiczc7990785b700lv64midjjgjnr7j6";
  };
  buildInputs = [ gettext kdelibs kde_baseapps ];
  meta = {
    description = "Norton/Total Commander clone for KDE";
    license = "GPL";
    homepage = http://www.krusader.org;
    maintainers = with stdenv.lib.maintainers; [ sander urkud ];
  };
}
