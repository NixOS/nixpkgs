{
  lib,
  stdenv,
  fetchFromGitHub,
  ocamlPackages,
}:

let
  inherit (ocamlPackages)
    ocaml
    findlib
    fmt
    ocamlgraph
    camlp-streams
    rresult
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "not-ocamlfind";
  version = "0.14";

  src = fetchFromGitHub {
    owner = "chetmurthy";
    repo = "not-ocamlfind";
    rev = finalAttrs.version;
    hash = "sha256-5hw2oIgZGFVELVgja+vmRx+7vacnFaYDS5FKYe+87nY=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    ocaml
    findlib
  ];

  buildInputs = [
    fmt
    ocamlgraph
    camlp-streams
    rresult
  ];

  configurePhase = ''
    ./configure \
      -bindir $out/bin \
      -config ${findlib}/etc/findlib.conf
  '';

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/lib/ocaml/${ocaml.version}/site-lib
  '';

  meta = with lib; {
    description = "Stub ocamlfind for building camlp5 without findlib dependency";
    homepage = "https://github.com/chetmurthy/not-ocamlfind";
    license = licenses.bsd2;
    platforms = platforms.all;
    maintainers = [ lib.maintainers.darkone ];
  };
})
