{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname   = "veryfasttree";
  version = "4.0";

  src = fetchFromGitHub {
    owner = "citiususc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ue3/2UTIQA6av+66xvGApLi9x0kM5vAmGHHTrboOaeQ=";
  };

  nativeBuildInputs = [ cmake ];

  installPhase = ''
    install -m755 -D VeryFastTree $out/bin/VeryFastTree
  '';

  meta = with lib; {
    description = "Speeding up the estimation of phylogenetic trees for large alignments through parallelization and vectorization strategies";
    license     = licenses.gpl3Plus;
    homepage    = "https://github.com/citiususc/veryfasttree";
    maintainers = with maintainers; [ thyol ];
  };
}
