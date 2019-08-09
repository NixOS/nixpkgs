{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "1.2.38";
  pname = "aragorn";

  src = fetchurl {
    url = "http://mbio-serv2.mbioekol.lu.se/ARAGORN/Downloads/${pname}${version}.tgz";
    sha256 = "09i1rg716smlbnixfm7q1ml2mfpaa2fpn3hwjg625ysmfwwy712b";
  };

  buildPhase = ''
    gcc -O3 -ffast-math -finline-functions -o aragorn aragorn${version}.c
  '';

  installPhase = ''
    mkdir -p $out/bin && cp aragorn $out/bin
    mkdir -p $out/man/1 && cp aragorn.1 $out/man/1
  '';

  meta = with stdenv.lib; {
    description = "Detects tRNA, mtRNA, and tmRNA genes in nucleotide sequences";
    homepage = http://mbio-serv2.mbioekol.lu.se/ARAGORN/;
    license = licenses.gpl2;
    maintainers = [ maintainers.bzizou ];
    platforms = platforms.unix;
  };
}
