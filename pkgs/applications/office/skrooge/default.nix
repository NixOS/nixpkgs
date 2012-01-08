{ stdenv, fetchurl, kdelibs, grantlee, qca2, libofx, gettext }:

stdenv.mkDerivation rec {
  name = "skrooge-1.1.1";

  src = fetchurl {
    url = "http://skrooge.org/files/${name}.tar.bz2";
    sha256 = "0qkd1hay7lglb0b4iw3arlwgm0yr8x789x7zf815skxvfhdaclv5";
  };

  buildInputs = [ kdelibs grantlee qca2 libofx ];

  buildNativeInputs = [ gettext ];

  meta = {
    inherit (kdelibs.meta) platforms;
    description = "A personal finance manager for KDE";
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
