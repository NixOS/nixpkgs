{ stdenv, fetchurl, pkgconfig, xlibs, libcompizconfig, glib
, python, pyrex }:

stdenv.mkDerivation rec {
  name = "compizconfig-python-0.8.4";

  src = fetchurl {
    url = "http://releases.compiz.org/components/compizconfig-python/${name}.tar.bz2";
    sha256 = "0nkgqxddjw324aymzcy5nx6ilhfbpk9rra4qbzrq3l39xqsswd37";
  };

  buildInputs = [ pkgconfig libcompizconfig glib python pyrex xlibs.xlibs ];

  NIX_LDFLAGS = "-lcompizconfig";

  meta = {
    homepage = http://www.compiz.org/;
    description = "Python interface to the Compiz configuration";
  };
}
