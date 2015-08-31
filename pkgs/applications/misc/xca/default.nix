{ stdenv, fetchurl, pkgconfig, which, openssl, qt4, libtool, gcc, makeWrapper }:

stdenv.mkDerivation rec {
  name = "xca-${version}";
  version = "1.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/xca/${name}.tar.gz";
    sha256 = "10rxma0zm7vryzv69m0aqlvmbf82d261wa77kxni4h3lndwqvpf2";
  };

  postInstall = ''
    wrapProgram "$out/bin/xca" \
      --prefix LD_LIBRARY_PATH : "${qt4}/lib:${gcc.cc}/lib:${gcc.cc}/lib64:${openssl}/lib:${libtool}/lib"
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
