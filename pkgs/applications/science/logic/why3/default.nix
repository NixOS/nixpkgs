{ fetchurl, stdenv, ocamlPackages, coq }:

stdenv.mkDerivation rec {
  name    = "why3-${version}";
  version = "1.1.0";

  src = fetchurl {
    url    = https://gforge.inria.fr/frs/download.php/file/37767/why3-1.1.0.tar.gz;
    sha256 = "199ziq8mv3r24y3dd1n2r8k2gy09p7kdyyhkg9qn1vzfd2fxwzc1";
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
