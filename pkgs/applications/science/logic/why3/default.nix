{ fetchurl, stdenv, ocamlPackages, coq }:

stdenv.mkDerivation rec {
  name    = "why3-${version}";
  version = "0.87.3";

  src = fetchurl {
    url    = https://gforge.inria.fr/frs/download.php/file/36398/why3-0.87.3.tar.gz;
    sha256 = "1fn9v6w1ilkrm2n4rz31w8qvjnchyvwxiqs67z3f59b5k99wb2ka";
  };

  buildInputs = (with ocamlPackages; [
      ocaml findlib lablgtk ocamlgraph zarith menhir ]) ++
    stdenv.lib.optionals (ocamlPackages.ocaml == coq.ocaml ) [
      coq coq.camlp5
    ];

  installTargets = [ "install" "install-lib" ];

  meta = with stdenv.lib; {
    description = "A platform for deductive program verification";
    homepage    = "http://why3.lri.fr/";
    license     = licenses.lgpl21;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice vbgl ];
  };
}
