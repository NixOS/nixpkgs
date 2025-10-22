{
  lib,
  stdenv,
  fetchFromGitHub,

  # OCaml packages
  ocamlPackages,

  # Other dependencies
  ocaml-crunch,

  # Runtime dependencies
  ninja, # Required for the build-system of catala

  pythonSupport ?
    lib.meta.availableOn stdenv.hostPlatform python3
    # Building with python in pkgsStatic gives this error:
    #  checking how to link an embedded Python application... configure: error: could not find shared library for Python
    && !stdenv.hostPlatform.isStatic
    # configure tries to call the python executable
    && stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  python3,

  javaSupport ?
    lib.meta.availableOn stdenv.hostPlatform jdk21_headless
    # configure tries to call the java executable
    && stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  jdk21_headless
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
  ];

  doCheck = true;

  buildInputs = with ocamlPackages; [
    ocolor
    bindlib
    cmdliner
    js_of_ocaml
    js_of_ocaml-ppx
    menhir
    menhirLib
    ocamlgraph
    re
    sedlex
    uucp
    ubase
    zarith
    zarith_stubs_js
    yojson
    crunch
    alcotest
    ninja_utils
    odoc
    ocamlformat
    cpdf
    otoml
    dates_calc
    visitors
    unionFind
    ninja
  ]
  ++ lib.optionals pythonSupport [
    (python3.withPackages(ps: with ps; [
      gmpy2
      dateutil
    ]))
  ]
  ++ lib.optionals javaSupport [ jdk21_headless ];

  meta = with lib; {
    description = "Domain-specific language for deriving faithful-by-construction algorithms from legislative texts";
    homepage = "https://catala-lang.org/";
    license = licenses.asl20;
    maintainers = with maintainers; [ mrdev023 ];
  };
}
