{ lib, fetchFromGitHub, ocamlPackages }:

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

buildDunePackage rec {
  pname = "opam-publish";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "ocaml-opam";
    repo = pname;
    rev = version;
    hash = "sha256-HjMba80c4vOEm9p7r0cfFBf3y0XoFf986XjTDCPzn38=";
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

  meta = with lib; {
    homepage = "https://github.com/ocaml-opam/${pname}";
    description = "Tool to ease contributions to opam repositories";
    mainProgram = "opam-publish";
    license = with licenses; [ lgpl21Only ocamlLgplLinkingException ];
    maintainers = with maintainers; [ niols ];
  };
}
