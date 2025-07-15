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
  version = "2025.06.0";

  src = fetchurl {
    url = "https://github.com/jasmin-lang/jasmin/releases/download/v${version}/jasmin-compiler-v${version}.tar.bz2";
    hash = "sha256-VjWNvg/aF+omobF8b4YpRwVYM5K/b0GLoe1P/83ilk8=";
  };

  nativeBuildInputs = with ocamlPackages; [
    ocaml
    findlib
    dune_3
    menhir
    camlidl
    cmdliner
  ];

  buildInputs =
    [
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

  installPhase = ''
    runHook preInstall
    pushd compiler
    dune build @install
    dune install --prefix=$bin --libdir=$out/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib
    popd
    mkdir -p $lib/lib/jasmin/easycrypt
    cp eclib/*.ec $lib/lib/jasmin/easycrypt
    runHook postInstall
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
