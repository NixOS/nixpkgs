{ stdenv, fetchurl, kdelibs, grantlee, qca2, libofx, gettext }:

stdenv.mkDerivation rec {
  name = "skrooge-1.3.2";

  src = fetchurl {
    url = "http://skrooge.org/files/${name}.tar.bz2";
    sha256 = "18j36yamxzfwpnnnjiach22q9088c2nlcilzh2p24gjhgnnd0v6r";
  };

  buildInputs = [ kdelibs grantlee qca2 libofx ];

  nativeBuildInputs = [ gettext ];

  meta = {
    inherit (kdelibs.meta) platforms;
    description = "A personal finance manager for KDE";
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
