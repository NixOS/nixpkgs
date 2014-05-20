{ stdenv, fetchurl, pkgconfig, which, openssl, qt4, libtool, gcc, makeWrapper }:

stdenv.mkDerivation rec {
  name = "xca-${version}";
  version = "0.9.3";

  src = fetchurl {
    url = "mirror://sourceforge/xca/${name}.tar.gz";
    sha256 = "1fn6kh8mdy65rrgjif7j9wn3mxg1mrrcnhzpi86hfy24ic6bahk8";
  };

  configurePhase = ''
    export PATH=$PATH:${which}/bin
    export QTDIR=${qt4}
    prefix=$out ./configure ${openssl} ${libtool}
  '';

  postInstall = ''
    wrapProgram "$out/bin/xca" \
      --prefix LD_LIBRARY_PATH : "${qt4}/lib:${gcc.gcc}/lib:${gcc.gcc}/lib64:${openssl}/lib:${libtool}/lib"
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
