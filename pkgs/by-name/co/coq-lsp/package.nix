{
  lib,
  stdenv,
  fetchFromGitHub,
  coq_8_20,
  makeWrapper,
}:

stdenv.mkDerivation rec {
  pname = "coq-lsp";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "ejgallego";
    repo = "coq-lsp";
    rev = "0.2.3+8.20";
    hash = "sha256-TUVS8jkgf1MMOOx5y70OaeZkdIgdgmyGQ2/zKxeplEk=";
  };

  nativeBuildInputs = with coq_8_20.ocamlPackages; [
    ocaml
    dune_3
    findlib
    makeWrapper
  ];

  buildInputs = [
    coq_8_20
  ]
  ++ (with coq_8_20.ocamlPackages; [
    cmdliner
    dune-build-info
    menhir
    ppx_compare
    ppx_deriving
    ppx_deriving_yojson
    ppx_hash
    ppx_import
    ppx_sexp_conv
    result
    sexplib
    uri
    yojson
  ]);

  buildPhase = ''
    runHook preBuild
    dune build -p ${pname} @install
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    dune install -p ${pname} --prefix=$out --libdir $OCAMLFIND_DESTDIR
    wrapProgram $out/bin/coq-lsp --prefix OCAMLPATH : $OCAMLPATH --prefix PATH : ${lib.makeBinPath [ coq_8_20 ]}
    runHook postInstall
  '';

  meta = with lib; {
    description = "Language Server Protocol implementation for Coq";
    longDescription = ''
      coq-lsp is a Language Server Protocol (LSP) implementation for the Coq
      proof assistant. It provides modern IDE features like syntax highlighting,
      error reporting, completion, and incremental compilation for Coq files.
    '';
    homepage = "https://github.com/ejgallego/coq-lsp";
    changelog = "https://github.com/ejgallego/coq-lsp/blob/0.2.3+8.20/CHANGES.md";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ thomasjm ];
    platforms = platforms.unix;
    mainProgram = "coq-lsp";
  };
}
