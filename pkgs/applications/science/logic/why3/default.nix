{ fetchurl, stdenv, ocaml, ocamlPackages, coq }:

stdenv.mkDerivation rec {
  name    = "why3-${version}";
  version = "0.86.1";

  src = fetchurl {
    url    = https://gforge.inria.fr/frs/download.php/file/34797/why3-0.86.1.tar.gz;
    sha256 = "129kzq79n8h480zrlphgh1ixvwp3wm18nbcky9bp4wdnr6zaibd7";
  };

  buildInputs = with ocamlPackages;
    [ coq coq.camlp5 ocaml findlib lablgtk ocamlgraph zarith menhir ];

  meta = with stdenv.lib; {
    description = "A platform for deductive program verification";
    homepage    = "http://why3.lri.fr/";
    license     = licenses.lgpl21;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice vbgl ];
  };
}
