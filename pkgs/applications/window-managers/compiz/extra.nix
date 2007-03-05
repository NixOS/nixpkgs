{ stdenv, fetchurl, pkgconfig, compiz, perl, perlXMLParser, GConf, dbus, gtk
}:

stdenv.mkDerivation {
  name = "compiz-extra-20070305";
  src = fetchurl {
    url = http://gandalfn.club.fr/ubuntu/compiz-extra/compiz-extra-latest.tar.bz2;
    sha256 = "1cm5cayhpnlhj0fhg8lqghdk52h9gmv4jv98zzadj3r3fd8mwr9z";
  };
  buildInputs = [
    pkgconfig compiz perl perlXMLParser GConf dbus gtk
  ];
  preBuild = "
    makeFlagsArray=(moduledir=$out/lib/compiz)
  ";
}
