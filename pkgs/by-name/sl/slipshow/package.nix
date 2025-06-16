{
  lib,
  ocamlPackages,
  fetchFromGitHub,
}:

ocamlPackages.buildDunePackage rec {
  pname = "slipshow";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "panglesd";
    repo = "slipshow";
    tag = "v${version}";
    hash = "sha256-1gjQDkjDxanshvn1fNxwpJFt12uRWnkmRbs0tWdTgtM=";
  };

  nativeBuildInputs = with ocamlPackages; [
    js_of_ocaml
    js_of_ocaml-compiler
  ];

  buildInputs = with ocamlPackages; [
    base64
    bos
    cmdliner
    dream
    fmt
    fpath
    logs
    lwt
    magic-mime
    ppx_blob
    irmin-watcher
    ppx_sexp_value
    sexplib
  ];

}
