{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  ocamlPackages,
}:
buildDunePackage (finalAttrs: {
  pname = "odep";
  version = "0.2.2";

  src = fetchFromGitHub {
    tag = finalAttrs.version;
    owner = "sim642";
    repo = "odep";
    hash = "sha256-1wpCiC6kC1dAFeez6ZZGKBKaDHBvh2tTXPQurmUHOyk=";
  };

  buildInputs = with ocamlPackages; [
    bos
    cmdliner
    findlib
    opam-state
    parsexp
    ppx_deriving
    sexplib
    ppx_sexp_conv
    ppx_deriving_yojson
  ];

  meta = {
    description = "Dependency graphs for OCaml modules, libraries and packages";
    homepage = "https://github.com/sim642/odep";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.GirardR1006 ];
  };
})
