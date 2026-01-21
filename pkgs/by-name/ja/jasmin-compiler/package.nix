{
  stdenv,
  lib,
  fetchurl,
  ocamlPackages,
  dune,
  mpfr,
  ppl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jasmin-compiler";
  version = "2025.06.3";

  src = fetchurl {
    url = "https://github.com/jasmin-lang/jasmin/releases/download/v${finalAttrs.version}/jasmin-compiler-v${finalAttrs.version}.tar.bz2";
    hash = "sha256-56r9iR61TonUHZ19G72p3bHN3F/fA1nYjCt7QXrko5s=";
  };

  nativeBuildInputs = with ocamlPackages; [
    ocaml
    findlib
    dune
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
})
