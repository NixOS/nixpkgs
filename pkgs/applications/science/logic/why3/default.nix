{ callPackage, fetchurl, stdenv
, ocamlPackages, coqPackages, rubber, hevea, emacs }:

stdenv.mkDerivation {
  pname = "why3";
  version = "1.2.0";

  src = fetchurl {
    url = https://gforge.inria.fr/frs/download.php/file/37903/why3-1.2.0.tar.gz;
    sha256 = "0xz001jhi71ja8vqrjz27v63bidrzj4qvg1yqarq6p4dmpxhk348";
  };

  buildInputs = with ocamlPackages; [
    ocaml findlib ocamlgraph zarith menhir
    # Compressed Sessions
    # Emacs compilation of why3.el
    emacs
    # Documentation
    rubber hevea
    # GUI
    lablgtk
    # WebIDE
    js_of_ocaml js_of_ocaml-ppx
    # Coq Support
    coqPackages.coq coqPackages.flocq ocamlPackages.camlp5
  ];

  propagatedBuildInputs = with ocamlPackages; [ camlzip num ];

  enableParallelBuilding = true;

  # Remove unnecessary call to which
  patches = [ ./configure.patch ];

  configureFlags = [ "--enable-verbose-make" ];

  installTargets = [ "install" "install-lib" ];

  passthru.withProvers = callPackage ./with-provers.nix {};

  meta = with stdenv.lib; {
    description = "A platform for deductive program verification";
    homepage    = "http://why3.lri.fr/";
    license     = licenses.lgpl21;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice vbgl ];
  };
}
