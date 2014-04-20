{ stdenv, fetchurl, cmake, qt4, perl, gettext, libXScrnSaver
, kdelibs, kdepimlibs, automoc4, phonon, qca2}:

let
  pn = "konversation";
  v = "1.5";
in

stdenv.mkDerivation rec {
  name = "${pn}-${v}";

  src = fetchurl {
    url = "mirror://kde/stable/${pn}/${v}/src/${name}.tar.xz";
    sha256 = "0vsl34kiar7kbsgncycwd7f66f493fip6d635qlprqn1gqhycb9q";
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
