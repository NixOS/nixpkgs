{
  ocamlPackages,
  fetchFromGitHub,
  lib,
}:

let
  pname = "satyrographos";
  version = "0.0.2.13";
  src = fetchFromGitHub {
    owner = "na4zagin3";
    repo = "satyrographos";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-f9iJTr4nV7dFCMkI8+zv9qvYWRSw8H/xbbZm2LR9cB4=";
  };
in
ocamlPackages.buildDunePackage {
  inherit pname version src;

  duneVersion = "3";

  nativeBuildInputs = with ocamlPackages; [
    menhir
  ];

  buildInputs = with ocamlPackages; [
    core_unix
    fileutils
    opam-format
    opam-state
    ppx_deriving
    ppx_deriving_yojson
    ppx_import
    ppx_jane
    shexp
    uri
    uri-sexp
    yaml-sexp
    yojson
  ];

  meta = {
    changelog = "https://github.com/na4zagin3/satyrographos/releases/tag/${src.rev}";
    description = "Package manager for SATySFi";
    homepage = "https://github.com/na4zagin3/satyrographos";
    maintainers = with lib.maintainers; [ momeemt ];
    mainProgram = "satyrographos";
    license = lib.licenses.lgpl3Plus;
  };
}
