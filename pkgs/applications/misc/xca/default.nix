{ mkDerivation, lib, fetchurl, pkgconfig, which
, libtool, openssl, qtbase, qttools }:

mkDerivation rec {
  name = "xca-${version}";
  version = "1.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/xca/${name}.tar.gz";
    sha256 = "1gygj6kljj3r1y0pg67mks36vfcz4vizjsqnqdvrk6zlgqjbzm7z";
  };

  enableParallelBuilding = true;

  buildInputs = [ libtool openssl qtbase qttools ];

  nativeBuildInputs = [ pkgconfig which ];

  configureFlags = [ "CXXFLAGS=-std=c++11" ];

  meta = with lib; {
    description = "Interface for managing asymetric keys like RSA or DSA";
    homepage    = http://xca.sourceforge.net/;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ offline peterhoeg ];
    platforms   = platforms.all;
  };
}
