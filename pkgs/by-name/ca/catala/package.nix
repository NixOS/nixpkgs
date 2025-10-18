{
  lib,
  fetchFromGitHub,

  # OCaml packages
  ocaml,
  ocamlPackages,

  # Python packages
  python3,
  python3Packages,

  # Other dependencies
  ocaml-crunch,
  obelisk,
  z3,
  nodejs,
  pandoc,
  ninja,
}:

let
  buildDunePackage = ocamlPackages.buildDunePackage;
in

buildDunePackage rec {
  pname = "catala";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "CatalaLang";
    repo = "catala";
    tag = version;
    sha256 = "sha256-JMDJJ+KIIlWMcKhKGUGwPy5+XoiVd0b/uXKAIn85n/Q=";
  };

  nativeBuildInputs = [
    ocaml-crunch
    ocamlPackages.cppo
    ocamlPackages.menhir
    ocamlPackages.menhirLib
    ocamlPackages.js_of_ocaml

    obelisk
    nodejs
    python3
    pandoc
    z3
    ninja
  ];

  buildInputs = [
    ocaml
    ocamlPackages.ocolor
    ocamlPackages.bindlib
    ocamlPackages.cmdliner
    ocamlPackages.js_of_ocaml
    ocamlPackages.js_of_ocaml-ppx
    ocamlPackages.menhir
    ocamlPackages.menhirLib
    ocamlPackages.ocamlgraph
    ocamlPackages.re
    ocamlPackages.sedlex
    ocamlPackages.uucp
    ocamlPackages.ubase
    ocamlPackages.zarith
    ocamlPackages.zarith_stubs_js
    ocamlPackages.yojson
    ocamlPackages.crunch
    ocamlPackages.alcotest
    ocamlPackages.ninja_utils
    ocamlPackages.odoc
    ocamlPackages.ocamlformat
    ocamlPackages.cpdf
    ocamlPackages.otoml
    ocamlPackages.dates_calc
    ocamlPackages.visitors
    ocamlPackages.unionFind

    python3
    python3Packages.gmpy2
    python3Packages.pygments
    python3Packages.pytest
    python3Packages.pytest-cov
  ];

  meta = with lib; {
    description = "A domain-specific language for deriving faithful-by-construction algorithms from legislative texts";
    homepage = "https://catala-lang.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mrdev023 ];
  };
}
