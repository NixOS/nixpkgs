{ stdenv, fetchFromGitHub, zlib, bzip2, lzma }:

stdenv.mkDerivation rec {
  pname = "freebayes";
  version = "1.3.1";

  src = fetchFromGitHub {
    name = "freebayes-${version}-src";
    owner  = "ekg";
    repo   = "freebayes";
    rev    = "v${version}";
    sha256 = "035nriknjqq8gvil81vvsmvqwi35v80q8h1cw24vd1gdyn1x7bys";
    fetchSubmodules = true;
  };

  buildInputs = [ zlib bzip2 lzma ];

  installPhase = ''
    install -vD bin/freebayes bin/bamleftalign scripts/* -t $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Bayesian haplotype-based polymorphism discovery and genotyping";
    license     = licenses.mit;
    homepage    = "https://github.com/ekg/freebayes";
    maintainers = with maintainers; [ jdagilliland ];
    platforms = [ "x86_64-linux" ];
  };
}
