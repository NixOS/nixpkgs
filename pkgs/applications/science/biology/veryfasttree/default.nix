{ lib, stdenv, fetchFromGitHub, cmake, llvmPackages}:

stdenv.mkDerivation rec {
  pname   = "veryfasttree";
  version = "4.0.1";

  src = fetchFromGitHub {
    owner = "citiususc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fv5ovi180Osok5GYJEidjMqmL8gZKUcxrcCQ/00lvi4=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = lib.optional stdenv.cc.isClang llvmPackages.openmp;

  installPhase = ''
    install -m755 -D VeryFastTree $out/bin/VeryFastTree
  '';

  meta = with lib; {
    description = "Speeding up the estimation of phylogenetic trees for large alignments through parallelization and vectorization strategies";
    license     = licenses.gpl3Plus;
    homepage    = "https://github.com/citiususc/veryfasttree";
    maintainers = with maintainers; [ thyol ];
    platforms   = platforms.all;
  };
}
