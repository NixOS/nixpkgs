{ stdenv, fetchurl, automoc4, cmake, gettext, perl, pkgconfig
, kdelibs4, kde_baseapps
}:

stdenv.mkDerivation rec {
  name = "krusader-2.4.0-beta1";
  src = fetchurl {
    url = "mirror://sourceforge/krusader/${name}.tar.bz2";
    sha256 = "1q1m4cjzz2m41pdpxnwrsiczc7990785b700lv64midjjgjnr7j6";
  };
  buildInputs = [ kdelibs4 kde_baseapps ];
  nativeBuildInputs = [ automoc4 cmake gettext perl pkgconfig ];
  NIX_CFLAGS_COMPILE = "-fpermissive"; # fix build with newer gcc versions
  meta = {
    description = "Norton/Total Commander clone for KDE";
    license = "GPL";
    homepage = http://www.krusader.org;
    maintainers = with stdenv.lib.maintainers; [ sander urkud ];
    inherit (kdelibs4.meta) platforms;
  };
}
