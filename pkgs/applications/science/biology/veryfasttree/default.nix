{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname   = "veryfasttree";
  version = "3.1.1";

  src = fetchFromGitHub {
    owner = "citiususc";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AOzbxUnrn1qgscjdOKf4dordnSKtIg3nSVaYWK1jbuc=";
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
