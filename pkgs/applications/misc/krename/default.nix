{ stdenv, fetchurl, cmake, automoc4, kdelibs, taglib, exiv2, podofo, gettext}:

stdenv.mkDerivation rec {
  name = "krename-4.0.4";

  src = fetchurl {
    url = "mirror://sourceforge/krename/${name}.tar.bz2";
    sha256 = "12qhclw1vbg5bv6619qd4408y8d1w26499gcr8gwhgfzk0v83hic";
  };

  buildInputs = [ cmake automoc4 kdelibs taglib exiv2 podofo gettext ];

  meta = {
    homepage = http://www.krename.net;
    description = "KRename is a powerful batch renamer for KDE";
    inherit (kdelibs.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
