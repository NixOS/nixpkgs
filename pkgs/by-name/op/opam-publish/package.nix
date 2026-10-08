{
  lib,
  fetchFromGitHub,
  ocamlPackages,
}:

let
  inherit (ocamlPackages)
    buildDunePackage
    cmdliner
    github
    github-unix
    lwt_ssl
    opam-core
    opam-format
    opam-state
    ;
in

buildDunePackage (finalAttrs: {
  pname = "opam-publish";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "ocaml-opam";
    repo = "opam-publish";
    tag = finalAttrs.version;
    hash = "sha256-/vKJrW907FIz8EA+ouIhEK2DUUctyTDKzeHl2CFAYUQ=";
  };

  buildInputs = [
    cmdliner
    lwt_ssl
    opam-core
    opam-format
    opam-state
    github
    github-unix
  ];

  meta = {
    homepage = "https://github.com/ocaml-opam/opam-publish";
    description = "Tool to ease contributions to opam repositories";
    mainProgram = "opam-publish";
    license = with lib.licenses; [
      lgpl21Only
      ocamlLgplLinkingException
    ];
    maintainers = with lib.maintainers; [ niols ];
  };
})
