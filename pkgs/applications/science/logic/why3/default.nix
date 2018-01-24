{ fetchurl, stdenv, ocamlPackages, coq }:

stdenv.mkDerivation rec {
  name    = "why3-${version}";
  version = "0.88.3";

  src = fetchurl {
    url    = https://gforge.inria.fr/frs/download.php/file/37313/why3-0.88.3.tar.gz;
    sha256 = "0limdqy9l5bjzwhdalcfdyh0b6laxgiphhvr4bby9p0030agssiy";
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
