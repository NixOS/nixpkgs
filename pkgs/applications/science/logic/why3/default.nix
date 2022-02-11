{ callPackage, fetchurl, fetchpatch, lib, stdenv
, ocamlPackages, coqPackages, rubber, hevea, emacs }:

stdenv.mkDerivation rec {
  pname = "why3";
  version = "1.4.0";

  src = fetchurl {
    url = "https://gforge.inria.fr/frs/download.php/file/38425/why3-${version}.tar.gz";
    sha256 = "0lw0cpx347zz9vvwqibmbxgs80fsd16scgk3isscvwxnajpc3rv8";
  };

  buildInputs = with ocamlPackages; [
    ocaml findlib ocamlgraph zarith menhir menhirLib
    # Emacs compilation of why3.el
    emacs
    # Documentation
    rubber hevea
    # GUI
    lablgtk3-sourceview3
    # WebIDE
    js_of_ocaml js_of_ocaml-ppx
    # S-expression output for why3pp
    ppx_deriving ppx_sexp_conv
    # Coq Support
    coqPackages.coq coqPackages.flocq
  ];

  propagatedBuildInputs = with ocamlPackages; [ camlzip num re sexplib ];

  enableParallelBuilding = true;

  configureFlags = [ "--enable-verbose-make" ];

  installTargets = [ "install" "install-lib" ];

  passthru.withProvers = callPackage ./with-provers.nix {};

  meta = with lib; {
    description = "A platform for deductive program verification";
    homepage    = "http://why3.lri.fr/";
    license     = licenses.lgpl21;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice vbgl ];
  };
}
