{ fetchurl, stdenv, ocamlPackages, coq }:

stdenv.mkDerivation rec {
  name    = "why3-${version}";
  version = "1.1.1";

  src = fetchurl {
    url = https://gforge.inria.fr/frs/download.php/file/37842/why3-1.1.1.tar.gz;
    sha256 = "065ix1ill009bxg7w27s8wq47vn03vbr63hsaa79arv31d96izny";
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
