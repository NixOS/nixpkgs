{ stdenv, fetchurl, cmake, qt4, perl, gettext, libXScrnSaver
, kdelibs, kdepimlibs, automoc4, phonon, qca2}:

let
  pn = "konversation";
  v = "1.5.1";
in

stdenv.mkDerivation rec {
  name = "${pn}-${v}";

  src = fetchurl {
    url = "mirror://kde/stable/${pn}/${v}/src/${name}.tar.xz";
    sha256 = "11hrjrq4r6v1v14ybx9llgzmrl3a45z26n292nb0q887rg1qv0wp";
  };

  buildInputs = [ cmake qt4 perl gettext libXScrnSaver kdelibs kdepimlibs
    automoc4 phonon qca2 ];

  meta = with stdenv.lib; {
    description = "Integrated IRC client for KDE";
    repositories.git = git://anongit.kde.org/konversation;
    license = "GPL";
    inherit (kdelibs.meta) maintainers platforms;
  };
}
