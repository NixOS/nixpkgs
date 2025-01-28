{
  lib,
  ocamlPackages,
  fetchFromGitHub,
}:

let
  mustache = import ../../../development/ocaml-modules/mustache/base.nix {
    inherit
      fetchFromGitHub
      ;
    buildDunePackage = ocamlPackages.buildDunePackage;
    menhirLib = ocamlPackages.menhirLib;
    ezjsonm = ocamlPackages.ezjsonm;
    ounit = ocamlPackages.ounit;
    doCheck = false; # tests need to mustache-cli, but it's recursive
    nativeBuildInputs = [
      ocamlPackages.menhir
    ];
  };
in
ocamlPackages.buildDunePackage rec {
  pname = "mustache-cli";
  inherit (mustache) version src;

  propagatedBuildInputs = with ocamlPackages; [
    cmdliner
    jsonm
    mustache
  ];

  doCheck = true;
  checkInputs = with ocamlPackages; [
    ezjsonm
    ounit2
  ];

  meta = {
    description = "CLI for Mustache logic-less templates";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ momeemt ];
    inherit (src.meta) homepage;
    mainProgram = "mustache-ocaml";
  };
}
