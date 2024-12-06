{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "cpptest";
  version = "2.0.0";

  src = fetchurl {
    url = "mirror://sourceforge/project/cpptest/cpptest/cpptest-${version}/cpptest-${version}.tar.gz";
    sha256 = "0lpy3f2fjx1srh02myanlp6zfi497whlldcrnij39ghfhm0arcnm";
  };

  meta = with lib; {
    homepage = "http://cpptest.sourceforge.net/";
    description = "Simple C++ unit testing framework";
    maintainers = with maintainers; [ bosu ];
    license = lib.licenses.lgpl3;
    platforms = platforms.all;
  };
}
