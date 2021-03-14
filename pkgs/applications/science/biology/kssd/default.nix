{ lib, stdenv, fetchurl, zlib, automake, autoconf, libtool }:

stdenv.mkDerivation rec {
  pname = "kssd";
  version = "1.1";

  src = fetchurl {
    url = "https://github.com/yhg926/public_${pname}/archive/v${version}.tar.gz";
    sha256 = "1x3v31cxnww4w5zn15vy0bwk53llsa0f97ma6qbw89h152d2mx5x";
  };

  buildInputs = [ zlib automake autoconf libtool ];

  installPhase = ''
      install -vD kssd $out/bin/kssd
  '';

  meta = with lib; {
    description = "K-mer substring space decomposition";
    license     = licenses.asl20;
    homepage    = "https://github.com/yhg926/public_kssd";
    maintainers = with maintainers; [ unode ];
    platforms = [ "x86_64-linux" ];
  };
}
