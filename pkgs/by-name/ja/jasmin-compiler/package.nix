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
  version = "2024.07.3";

  src = fetchurl {
    url = "https://github.com/jasmin-lang/jasmin/releases/download/v${version}/jasmin-compiler-v${version}.tar.bz2";
    hash = "sha256-z5J4zxnsykNWXeAfS0GhU4oK0GJFa5qca9HhgzWx/34=";
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
