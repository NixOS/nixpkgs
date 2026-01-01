{
  stdenv,
  lib,
  fetchurl,
<<<<<<< HEAD
  ocamlPackages,
  dune,
=======
  dune_3,
  ocamlPackages,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  mpfr,
  ppl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "jasmin-compiler";
<<<<<<< HEAD
  version = "2025.06.3";

  src = fetchurl {
    url = "https://github.com/jasmin-lang/jasmin/releases/download/v${finalAttrs.version}/jasmin-compiler-v${finalAttrs.version}.tar.bz2";
    hash = "sha256-56r9iR61TonUHZ19G72p3bHN3F/fA1nYjCt7QXrko5s=";
=======
  version = "2025.06.2";

  src = fetchurl {
    url = "https://github.com/jasmin-lang/jasmin/releases/download/v${finalAttrs.version}/jasmin-compiler-v${finalAttrs.version}.tar.bz2";
    hash = "sha256-qg0h9TLBVgoJOSRM/RyEFLorQsnRQDlg9FhQBEbLHrs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = with ocamlPackages; [
    ocaml
    findlib
<<<<<<< HEAD
    dune
=======
    dune_3
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
