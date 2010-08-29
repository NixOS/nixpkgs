{ stdenv, fetchurl, cmake, qt4, perl, gettext, libXScrnSaver
, kdelibs, kdepimlibs, automoc4, phonon, qca2}:

let
  pn = "konversation";
  v = "1.3.1";
in

stdenv.mkDerivation rec {
  name = "${pn}-${v}";

  src = fetchurl {
    url = "mirror://kde/stable/${pn}/${v}/src/${name}.tar.bz2";
    sha256 = "0wigcvi6lscy14dhm5nh1mkhfx7xxdq9g163pwpd0xndvybrfhfl";
  };

  buildInputs = [ cmake qt4 perl gettext libXScrnSaver kdelibs kdepimlibs
    automoc4 phonon qca2 ];

  meta = with stdenv.lib; {
    description = "Integrated IRC client for KDE";
    license = "GPL";
    inherit (kdelibs.meta) maintainers platforms;
  };
}
