{ mkDerivation, lib, fetchFromGitHub, autoreconfHook, perl, pkgconfig, which
, libtool, openssl, qtbase, qttools }:

mkDerivation rec {
  name = "xca-${version}";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner  = "chris2511";
    repo   = "xca";
    rev    = "RELEASE.${version}";
    sha256 = "0906xnmqzd9q5irxzm19361vhzig9yqsmf6wsc3rggniix5bk3a8";
  };

  postPatch = ''
    substituteInPlace doc/code2html \
      --replace /usr/bin/perl ${perl}/bin/perl
  '';

  buildInputs = [ libtool openssl qtbase qttools ];

  nativeBuildInputs = [ autoreconfHook pkgconfig which ];

  enableParallelBuilding = true;

  configureFlags = [ "CXXFLAGS=-std=c++11" ];

  meta = with lib; {
    description = "Interface for managing asymetric keys like RSA or DSA";
    homepage    = http://xca.sourceforge.net/;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ offline peterhoeg ];
    platforms   = platforms.all;
  };
}
