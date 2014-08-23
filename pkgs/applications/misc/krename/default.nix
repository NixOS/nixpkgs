{ stdenv, fetchurl, cmake, automoc4, kdelibs, taglib, exiv2, podofo, gettext, qt4, phonon }:

stdenv.mkDerivation rec {
  name = "krename-4.0.9";

  src = fetchurl {
    url = "mirror://sourceforge/krename/${name}.tar.bz2";
    sha256 = "11bdg5vdcs393n0aibhm3jh3wxlk5kz78jhkwf7cj9086qkg9wds";
  };

  buildInputs = [ cmake automoc4 kdelibs taglib exiv2 podofo gettext qt4 phonon ];

  meta = {
    homepage = http://www.krename.net;
    description = "KRename is a powerful batch renamer for KDE";
    inherit (kdelibs.meta) platforms;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
