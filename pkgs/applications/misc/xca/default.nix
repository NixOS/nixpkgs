{ mkDerivation, lib, fetchFromGitHub, autoreconfHook, perl, pkgconfig
, libtool, openssl, qtbase, qttools }:

mkDerivation rec {
  name = "xca-${version}";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner  = "chris2511";
    repo   = "xca";
    rev    = "RELEASE.${version}";
    sha256 = "1d09329a80axwqhxixwasd8scsmh23vsq1076amy5c8173s4ambi";
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
