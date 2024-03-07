{ callPackage, fetchurl, lib, stdenv
, ocamlPackages, coqPackages, rubber, hevea, emacs
, version ? "1.7.0"
}:

stdenv.mkDerivation rec {
  pname = "why3";
  inherit version;

  src = fetchurl {
    url = "https://why3.gitlabpages.inria.fr/releases/${pname}-${version}.tar.gz";
    hash = {
      "1.7.0" = "sha256-rygrjzuJVukOvpuXTG/yeoEP98ZFkLQHObgc3My1PVY=";
      "1.6.0" = "sha256-hFvM6kHScaCtcHCc6Vezl9CR7BFbiKPoTEh7kj0ZJxw=";
    }."${version}";
  };

  strictDeps = true;

  nativeBuildInputs = with ocamlPackages;  [
    ocaml findlib menhir
    # Coq Support
    coqPackages.coq
  ];

  buildInputs = with ocamlPackages; [
    ocamlgraph zarith
    # Emacs compilation of why3.el
    emacs
    # Documentation
    rubber hevea
    # GUI
    lablgtk3-sourceview3
    # WebIDE
    js_of_ocaml js_of_ocaml-ppx
    # S-expression output for why3pp
    ppx_deriving ppx_sexp_conv ]
    ++
    # Coq Support
    (with coqPackages; [ coq flocq ])
  ;

  propagatedBuildInputs = with ocamlPackages; [ camlzip menhirLib num re sexplib ];

  enableParallelBuilding = true;

  configureFlags = [ "--enable-verbose-make" ];

  installTargets = [ "install" "install-lib" ];

  passthru.withProvers = callPackage ./with-provers.nix {};

  meta = with lib; {
    description = "A platform for deductive program verification";
    homepage    = "https://why3.lri.fr/";
    license     = licenses.lgpl21;
    platforms   = platforms.unix;
    maintainers = with maintainers; [ thoughtpolice vbgl ];
  };
}
