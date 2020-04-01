{ callPackage, fetchurl, fetchpatch, stdenv
, ocamlPackages, coqPackages, rubber, hevea, emacs }:

stdenv.mkDerivation {
  pname = "why3";
  version = "1.2.1";

  src = fetchurl {
    url = https://gforge.inria.fr/frs/download.php/file/38185/why3-1.2.1.tar.gz;
    sha256 = "014gkwisjp05x3342zxkryb729p02ngx1hcjjsrplpa53jzgz647";
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
  patches = [ ./configure.patch
    # Compatibility with js_of_ocaml 3.5
    (fetchpatch {
      url = "https://gitlab.inria.fr/why3/why3/commit/269ab313382fe3e64ef224813937314748bf7cf0.diff";
      sha256 = "0i92wdnbh8pihvl93ac0ma1m5g95jgqqqj4kw6qqvbbjjqdgvzwa";
    })
  ];

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
