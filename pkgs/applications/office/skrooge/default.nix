{ stdenv, fetchurl, kdelibs, grantlee, qca2, libofx, gettext }:

stdenv.mkDerivation rec {
  name = "skrooge-1.3.0";

  src = fetchurl {
    url = "http://skrooge.org/files/${name}.tar.bz2";
    sha256 = "1sfzzn9xz01c0095w4scckiiwv2gfbaxx05h7ds5n02a113w53kz";
  };

  buildInputs = [ kdelibs grantlee qca2 libofx ];

  buildNativeInputs = [ gettext ];

  meta = {
    inherit (kdelibs.meta) platforms;
    description = "A personal finance manager for KDE";
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
