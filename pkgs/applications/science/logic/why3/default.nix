{ fetchurl, stdenv, ocamlPackages, coq }:

stdenv.mkDerivation rec {
  name    = "why3-${version}";
  version = "0.86.3";

  src = fetchurl {
    url    = https://gforge.inria.fr/frs/download.php/file/35537/why3-0.86.3.tar.gz;
    sha256 = "0sph6i4ga9450bk60wpm5cq3psw3g8xprnac7yjfq64iqz1dyz03";
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
