{ mkDerivation, lib, fetchFromGitHub, autoreconfHook, perl, pkgconfig
, libtool, openssl, qtbase, qttools }:

mkDerivation rec {
  pname = "xca";
  version = "2.1.2";

  src = fetchFromGitHub {
    owner  = "chris2511";
    repo   = "xca";
    rev    = "RELEASE.${version}";
    sha256 = "0slfqmz0b01lwmrv4h78hmrsdrhcyc7sjzsxcw05ylgmhvdq3dw9";
  };

  postPatch = ''
    substituteInPlace doc/code2html \
      --replace /usr/bin/perl ${perl}/bin/perl
  '';

  buildInputs = [ libtool openssl qtbase ];

  nativeBuildInputs = [ autoreconfHook pkgconfig qttools ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "An x509 certificate generation tool, handling RSA, DSA and EC keys, certificate signing requests (PKCS#10) and CRLs";
    homepage    = https://hohnstaedt.de/xca/;
    license     = licenses.bsd3;
    maintainers = with maintainers; [ offline peterhoeg ];
    platforms   = platforms.all;
  };
}
