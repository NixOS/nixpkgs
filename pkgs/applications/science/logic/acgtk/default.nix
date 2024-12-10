{
  lib,
  stdenv,
  fetchFromGitLab,
  dune_3,
  ocamlPackages,
}:

stdenv.mkDerivation {

  pname = "acgtk";
  version = "2.0.0";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "acg";
    repo = "dev/acgtk";
    rev = "release-2.0.0-20231009";
    hash = "sha256-ZymSQkBMBePPw7pJkfLkmqbIkQyIqB+7Pyrih2WAO50=";
  };

  strictDeps = true;

  nativeBuildInputs = with ocamlPackages; [
    menhir
    ocaml
    findlib
    dune_3
  ];

  buildInputs = with ocamlPackages; [
    ansiterminal
    cairo2
    cmdliner
    fmt
    logs
    menhirLib
    mtime
    ocamlgraph
    readline
    sedlex
    yojson
  ];

  buildPhase = ''
    runHook preBuild
    dune build --profile=release ''${enableParallelBuilding:+-j $NIX_BUILD_CORES}
    runHook postBuild
  '';

  installPhase = ''
    dune install --prefix $out --libdir $OCAMLFIND_DESTDIR
  '';

  meta = with lib; {
    homepage = "https://acg.loria.fr/";
    description = "A toolkit for developing ACG signatures and lexicon";
    license = licenses.cecill20;
    inherit (ocamlPackages.ocaml.meta) platforms;
    maintainers = [ maintainers.jirkamarsik ];
  };
}
