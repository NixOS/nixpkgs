{ stdenv, fetchFromGitHub, cmake, gcc, zlib, bzip2, lzma }:

stdenv.mkDerivation rec {
  name    = "freebayes-${version}";
  version = "2017-08-23";

  src = fetchFromGitHub {
    name = "freebayes-${version}-src";
    owner  = "ekg";
    repo   = "freebayes";
    rev    = "8d2b3a060da473e1f4f89be04edfce5cba63f1d3";
    sha256 = "0yyrgk2639lz1yvg4jf0ccahnkic31dy77q05pb3i28rjf37v45z";
    fetchSubmodules = true;
  };

  buildInputs = [ zlib bzip2 lzma ];

  installPhase = ''
    install -vD bin/freebayes bin/bamleftalign scripts/* -t $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Bayesian haplotype-based polymorphism discovery and genotyping";
    license     = licenses.mit;
    homepage    = https://github.com/ekg/freebayes;
    maintainers = with maintainers; [ jdagilliland ];
    platforms = [ "x86_64-linux" ];
  };
}
