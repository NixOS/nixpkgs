{ fetchurl, stdenv, ocamlPackages, coq }:

stdenv.mkDerivation rec {
  name    = "why3-${version}";
  version = "1.0.0";

  src = fetchurl {
    url    = https://gforge.inria.fr/frs/download.php/file/37604/why3-1.0.0.tar.gz;
    sha256 = "18h00diw1c051v7ya0lv09ns5630qi9savwffx0652mcc4b4qpxn";
  };

  buildInputs = (with ocamlPackages; [
      ocaml findlib num lablgtk ocamlgraph zarith menhir ]) ++
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
