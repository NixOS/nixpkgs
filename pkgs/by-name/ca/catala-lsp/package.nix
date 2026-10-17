{
  lib,
  fetchFromGitHub,

  # OCaml packages
  ocamlPackages,

  # Other dependencies
  catala,
}:

let
  buildDunePackage = ocamlPackages.buildDunePackage;
in

buildDunePackage rec {
  pname = "catala-lsp";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "CatalaLang";
    repo = "catala-language-server";
    tag = version;
    sha256 = "sha256-E97Y6sPrDU6xxzY1zHP3lH94Ol3sO8gvmghnBZYLr6g=";
  };

  doCheck = true;

  nativeBuildInputs = with ocamlPackages; [
    atdgen
  ];

  buildInputs = with ocamlPackages; [
    catala
    logs
    uri
    linol
    linol-lwt
    dap
    atdgen-runtime
    ptime
  ];

  checkInputs = with ocamlPackages; [
    qcheck
    tezt
  ];

  meta = {
    description = "Catala LSP server";
    homepage = "https://catala-lang.org/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      mrdev023
      jk
    ];
  };
}
