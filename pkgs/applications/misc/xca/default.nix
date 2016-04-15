{ stdenv, fetchurl, pkgconfig, which, openssl, qt4, libtool, gcc, makeWrapper }:

stdenv.mkDerivation rec {
  name = "xca-${version}";
  version = "1.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/xca/${name}.tar.gz";
    sha256 = "1r2w9gpahjv221j963bd4vn0gj4cxmb9j42f3cd9qdn890hizw84";
  };

  postInstall = ''
    wrapProgram "$out/bin/xca" \
      --prefix LD_LIBRARY_PATH : \
        "${gcc.cc.lib}/lib64:${stdenv.lib.makeLibraryPath [ qt4 gcc.cc openssl libtool ]}"
  '';

  buildInputs = [ openssl qt4 libtool gcc makeWrapper ];
  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "Interface for managing asymetric keys like RSA or DSA";
    homepage = http://xca.sourceforge.net/;
    platforms = platforms.all;
    license = licenses.bsd3;
  };
}
