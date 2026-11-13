{
  lib,
  fetchFromGitLab,
  ocaml-ng,
}:

let
  ocamlPackages = ocaml-ng.ocamlPackages_4_14;

in
ocamlPackages.buildDunePackage (
  finalAttrs:
  let
    colibrilib = ocamlPackages.buildDunePackage {
      pname = "colibrilib";
      inherit (finalAttrs) version src;
      __structuredAttrs = true;

      propagatedBuildInputs = with ocamlPackages; [
        zarith
      ];

      meta = finalAttrs.meta // {
        description = "A library of domains and propagators proved in Why3";
      };
    };

  in
  {
    pname = "colibri2";
    version = "0.6";

    __structuredAttrs = true;

    src = fetchFromGitLab {
      owner = "pub";
      repo = "colibrics";
      domain = "git.frama-c.com";
      tag = finalAttrs.version;
      hash = "sha256-xuPFXonA6O/G+14Y3eglBTAtauBPewyYX9OXfEIe/6g=";
    };

    checkInputs = with ocamlPackages; [
      ounit2
    ];

    propagatedBuildInputs = with ocamlPackages; [
      colibrilib
      flint
      cmdliner
      containers
      dolmen
      dolmen_loop
      dolmen_type
      dune-build-info
      farith
      gen
      gmap
      ocamlgraph
      ocplib-simplex
      ppx_deriving
      ppx_hash
      ppx_here
      ppx_inline_test
      ppx_optcomp
      patricia-tree
      qcheck-core
      re
      trace
      trace-tef
      zarith
      mlcuddidl
    ];

    meta = {
      description = "A CP solver for smtlib";
      homepage = "https://colibri.frama-c.com/";
      license = lib.licenses.lgpl21Only;
      maintainers = with lib.maintainers; [ luc65r ];
    };
  }
)
