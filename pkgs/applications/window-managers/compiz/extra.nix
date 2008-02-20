{ stdenv, fetchurl, pkgconfig, compiz, perl, perlXMLParser, GConf, dbus, gtk
}:

stdenv.mkDerivation {
  name = "compiz-extra-20070305";
  src = fetchurl {
    url = http://gandalfn.club.fr/ubuntu/compiz-extra/compiz-extra-latest.tar.bz2;
    sha256 = "7fc7faafccfdf22dea7ac1de6629dcb55ec63d84fcb57a14559309cf284fa94f";
  };
  buildInputs = [
    pkgconfig compiz perl perlXMLParser GConf dbus.libs gtk
  ];
  preBuild = "
    makeFlagsArray=(moduledir=$out/lib/compiz)
  ";
  preConfigure = "touch m4/Makefile.in";
}
