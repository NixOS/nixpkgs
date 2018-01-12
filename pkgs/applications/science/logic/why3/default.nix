{ fetchurl, stdenv, ocamlPackages, coq }:

stdenv.mkDerivation rec {
  name    = "why3-${version}";
  version = "0.88.1";

  src = fetchurl {
    url    = https://gforge.inria.fr/frs/download.php/file/37185/why3-0.88.1.tar.gz;
    sha256 = "1qj00963si0vdrqjp79ai27g9rr8sqvly6n6nwpga6bnss98xqkw";
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
