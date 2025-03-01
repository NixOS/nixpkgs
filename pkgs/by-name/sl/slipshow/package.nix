{
  lib,
  ocamlPackages,
  fetchFromGitHub,
}:

ocamlPackages.buildDunePackage rec {
  pname = "slipshow";
  version = "0.0.33";

  src = fetchFromGitHub {
    owner = "panglesd";
    repo = "slipshow";
    tag = "v${version}";
    hash = "sha256-fmP4fRISk8aQIdmP1HRCMvnsg3omDaLdA+RPdnV5R9Q=";
  };

  buildInputs = [
    ocamlPackages.cmdliner
    ocamlPackages.base64
    ocamlPackages.bos
    ocamlPackages.lwt
    ocamlPackages.irmin-watcher
    ocamlPackages.js_of_ocaml-compiler
    ocamlPackages.js_of_ocaml-lwt
    ocamlPackages.magic-mime
    ocamlPackages.dream
    ocamlPackages.fpath
    ocamlPackages.brr
    ocamlPackages.ppx_blob
    ocamlPackages.sexplib
    ocamlPackages.ppx_sexp_conv
  ];

  nativeBuildInputs = [ ocamlPackages.js_of_ocaml ];

  meta = {
    homepage = "https://github.com/panglesd/slipshow/";
    description = "Engine for displaying slips, the next-gen version of slides";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.ankhers ];
    platforms = lib.platforms.linux;
  };
}
