{ mkDerivation, lib, fetchFromGitHub, autoreconfHook, perl, pkgconfig, which
, libtool, openssl, qtbase, qttools }:

mkDerivation rec {
  name = "xca-${version}";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner  = "chris2511";
    repo   = "xca";
    rev    = "RELEASE.${version}";
    sha256 = "039qz6hh43hx8dcw2bq71mgy95zk09jyd3xxpldmxxd5d69zcr8m";
  };

  postPatch = ''
    substituteInPlace doc/code2html \
      --replace /usr/bin/perl ${perl}/bin/perl
  '';

  buildInputs = [ libtool openssl qtbase qttools ];

  nativeBuildInputs = [ autoreconfHook pkgconfig which ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Interface for managing asymetric keys like RSA or DSA";
    homepage    = http://xca.sourceforge.net/;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ offline peterhoeg ];
    platforms   = platforms.all;
  };
}
