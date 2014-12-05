{ fetchurl, stdenv, ocaml, ocamlPackages, coq }:

stdenv.mkDerivation rec {
  name    = "why3-${version}";
  version = "0.85";

  src = fetchurl {
    url    = "https://gforge.inria.fr/frs/download.php/34074/why3-0.85.tar.gz";
    sha256 = "0sj1pd50lqvnvyss1f8ysgigdi64s91rrpdrmp7crmcy1npa8apf";
  };

  buildInputs = with ocamlPackages;
    [ coq ocaml findlib lablgtk ocamlgraph zarith ];

  meta = with stdenv.lib; {
    description = "A platform for deductive program verification";
    homepage    = "http://why3.lri.fr/";
    license     = licenses.lgpl21;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice vbgl ];
  };
}
