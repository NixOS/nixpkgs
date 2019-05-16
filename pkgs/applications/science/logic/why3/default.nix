{ fetchurl, stdenv, ocamlPackages, coq }:

stdenv.mkDerivation rec {
  name    = "why3-${version}";
  version = "1.2.0";

  src = fetchurl {
    url = https://gforge.inria.fr/frs/download.php/file/37903/why3-1.2.0.tar.gz;
    sha256 = "0xz001jhi71ja8vqrjz27v63bidrzj4qvg1yqarq6p4dmpxhk348";
  };

  buildInputs = (with ocamlPackages; [
      ocaml findlib num lablgtk ocamlgraph zarith menhir ]) ++
    stdenv.lib.optionals (ocamlPackages.ocaml == coq.ocamlPackages.ocaml ) [
      coq ocamlPackages.camlp5
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
