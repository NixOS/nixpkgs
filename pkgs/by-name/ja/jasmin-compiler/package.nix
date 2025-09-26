{
  stdenv,
  lib,
  fetchurl,
  ocamlPackages,
  mpfr,
  ppl,
}:

stdenv.mkDerivation rec {
  pname = "jasmin-compiler";
  version = "2025.06.1";

  src = fetchurl {
    url = "https://github.com/jasmin-lang/jasmin/releases/download/v${version}/jasmin-compiler-v${version}.tar.bz2";
    hash = "sha256-6StC+mnafHMLDCbaz4QqcrT+vK9PIVeh3BizzOH4Wfo=";
  };

  nativeBuildInputs = with ocamlPackages; [
    ocaml
    findlib
    dune_3
    menhir
    camlidl
    cmdliner
  ];

  buildInputs = [
    mpfr
    ppl
  ]
  ++ (with ocamlPackages; [
    apron
    yojson
  ]);

  propagatedBuildInputs = with ocamlPackages; [
    angstrom
    batteries
    menhirLib
    zarith
  ];

  outputs = [
    "bin"
    "lib"
    "out"
  ];

  preInstall = ''
    export PREFIX=$lib
    export DUNE_OPTS="--prefix=$bin --libdir=$out/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib"
  '';

  meta = {
    description = "Workbench for high-assurance and high-speed cryptography";
    homepage = "https://github.com/jasmin-lang/jasmin/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
    mainProgram = "jasminc";
    platforms = lib.platforms.all;
  };
}
