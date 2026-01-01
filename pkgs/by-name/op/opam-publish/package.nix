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

<<<<<<< HEAD
buildDunePackage (finalAttrs: {
  pname = "opam-publish";
  version = "2.7.1";
=======
buildDunePackage rec {
  pname = "opam-publish";
  version = "2.7.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ocaml-opam";
    repo = "opam-publish";
<<<<<<< HEAD
    tag = finalAttrs.version;
    hash = "sha256-yaFkR+MxkN6/skXx9euKVjTGXk9DraxDj+/2XQuHK4I=";
=======
    rev = version;
    hash = "sha256-Li7Js8mrxOrRNNuu8z4X+VXbuECfk7Gsgpy4d6R3RwU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
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
=======
  meta = with lib; {
    homepage = "https://github.com/ocaml-opam/opam-publish";
    description = "Tool to ease contributions to opam repositories";
    mainProgram = "opam-publish";
    license = with licenses; [
      lgpl21Only
      ocamlLgplLinkingException
    ];
    maintainers = with maintainers; [ niols ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
