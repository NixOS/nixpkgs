{ stdenv, fetchurl, zlib, automake, autoconf, libtool }:

stdenv.mkDerivation rec {
  pname = "kssd";
  version = "1.0";

  src = fetchurl {
    url = "https://github.com/yhg926/public_${pname}/archive/v${version}.tar.gz";
    sha256 = "a5dcaf520049a962bef625cb59a567ea2b4252d4dc9be28dd06123d340e03919";
  };

  buildInputs = [ zlib automake autoconf libtool ];

  installPhase = ''
      install -vD kssd $out/bin/kssd
  '';

  meta = with stdenv.lib; {
    description = "K-mer substring space decomposition";
    license     = licenses.asl20;
    homepage    = "https://github.com/yhg926/public_kssd";
    maintainers = with maintainers; [ unode ];
    platforms = [ "x86_64-linux" ];
  };
}
