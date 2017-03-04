{ stdenv, fetchurl, pkgconfig, which, makeQtWrapper,
  libtool, openssl, qtbase, qttools }:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "xca-${version}";
  version = "1.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/xca/${name}.tar.gz";
    sha256 = "1r2w9gpahjv221j963bd4vn0gj4cxmb9j42f3cd9qdn890hizw84";
  };

  enableParallelBuilding = false;

  buildInputs = [ libtool openssl qtbase qttools ];

  nativeBuildInputs = [ makeQtWrapper pkgconfig which ];

  configureFlags = [ "CXXFLAGS=-std=c++11" ];

  preBuild = ''
    substituteInPlace Local.mak \
      --replace ${qtbase}/bin/moc ${qtbase.dev}/bin/moc \
      --replace ${qtbase}/bin/uic ${qtbase.dev}/bin/uic
  '';

  postInstall = ''
    wrapQtProgram "$out/bin/xca"
    wrapQtProgram "$out/bin/xca_db_stat"
  '';

  meta = with stdenv.lib; {
    description = "Interface for managing asymetric keys like RSA or DSA";
    homepage = http://xca.sourceforge.net/;
    platforms = platforms.all;
    license = licenses.bsd3;
    maintainers = with maintainers; [ offline peterhoeg ];
  };
}
