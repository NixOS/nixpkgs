{ fetchurl, stdenv, ocamlPackages, coq }:

stdenv.mkDerivation rec {
  name    = "why3-${version}";
  version = "0.86.2";

  src = fetchurl {
    url    = https://gforge.inria.fr/frs/download.php/file/35214/why3-0.86.2.tar.gz;
    sha256 = "08sa7dmp6yp29xn0m6h98nic4q47vb4ahvaid5drwh522pvwvg10";
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
