{
  lib,
  ocamlPackages,
  fetchFromGitHub,
}:
ocamlPackages.buildDunePackage rec {
  pname = "hardcaml";
  version = "v0.17";

  minimalOCamlVersion = "5.1.0";

  src = fetchFromGitHub {
    owner = "janestreet";
    repo = "hardcaml";
    rev = version;
    hash = "sha256-lRzqXuUYrk3VjQhFDTN0Q/aPolf0gKr4gK0i1ZOKKww=";
  };

  buildInputs = with ocamlPackages; [
    base
    bin_prot
    core
    core_kernel
    ppx_jane
    sexplib
    stdio
    topological_sort
    zarith
  ];

  meta = {
    homepage = "https://github.com/janestreet/hardcaml/tree/master";
    description = "Hardcaml is an OCaml library for designing hardware";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jleightcap ];
  };
}
