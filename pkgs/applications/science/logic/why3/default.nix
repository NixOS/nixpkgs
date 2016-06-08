{ fetchurl, stdenv, ocamlPackages, coq }:

stdenv.mkDerivation rec {
  name    = "why3-${version}";
  version = "0.87.1";

  src = fetchurl {
    url    = https://gforge.inria.fr/frs/download.php/file/35893/why3-0.87.1.tar.gz;
    sha256 = "1ssik2f6fkpvwpdmxz8hrm3p62qas3sjlqya0r57s60ilpkgiwwb";
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
