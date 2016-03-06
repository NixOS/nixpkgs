{ stdenv, fetchurl, cmake, qt4, perl, gettext, libXScrnSaver
, kdelibs, kdepimlibs, automoc4, pkgconfig, phonon, qca2, qjson, qoauth }:

let
  pn = "choqok";
  v = "1.5";
in

stdenv.mkDerivation rec {
  name = "${pn}-${v}";

  src = fetchurl {
    url = "mirror://sourceforge/project/choqok/Choqok/choqok-1.5.tar.xz";
    sha256 = "5cb97ac4cdf9db4699bb7445a9411393073d213fea649ab0713f659f1308efe4";
  };

  buildInputs = [ cmake qt4 perl gettext libXScrnSaver kdelibs kdepimlibs
    automoc4 pkgconfig phonon qca2 qjson qoauth ];

  meta = with stdenv.lib; {
    description = "A KDE microblogging client";
    repositories.git = git://anongit.kde.org/choqok;
    license = "GPL";
    inherit (kdelibs.meta) maintainers platforms;
  };
}
