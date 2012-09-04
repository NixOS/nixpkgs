{ stdenv, fetchurl, cmake, qt4, perl, gettext, libXScrnSaver
, kdelibs, kdepimlibs, automoc4, phonon, qca2}:

let
  pn = "konversation";
  v = "1.4";
in

stdenv.mkDerivation rec {
  name = "${pn}-${v}";

  src = fetchurl {
    url = "mirror://kde/stable/${pn}/${v}/src/${name}.tar.xz";
    sha256 = "030vsbb18dlzsnjl3fzyd1m9wvvksiyc1lm45abi4q6x4xd60knv";
  };

  buildInputs = [ cmake qt4 perl gettext libXScrnSaver kdelibs kdepimlibs
    automoc4 phonon qca2 ];

  meta = with stdenv.lib; {
    description = "Integrated IRC client for KDE";
    license = "GPL";
    inherit (kdelibs.meta) maintainers platforms;
  };
}
