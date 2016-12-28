{ stdenv, fetchFromGitHub, cmake, gcc, zlib}:

stdenv.mkDerivation rec {
  name    = "freebayes-${version}";
  version = "1.1.0";

  src = fetchFromGitHub {
    name = "freebayes-${version}-src";
    owner  = "ekg";
    repo   = "freebayes";
    rev    = "refs/tags/v${version}";
    sha256 = "0xb8aicb36w9mfs1gq1x7mcp3p82kl7i61d162hfncqzg2npg8rr";
    fetchSubmodules = true;
  };

  buildInputs = [ cmake gcc zlib ];

  builder = ./builder.sh;

  meta = with stdenv.lib; {
    description = "Bayesian haplotype-based polymorphism discovery and genotyping";
    license     = licenses.mit;
    homepage    = https://github.com/ekg/freebayes;
    maintainers = with maintainers; [ jdagilliland ];
    platforms = [ "x86_64-linux" ];
  };
}
