{
  lib,
  stdenv,
  fetchFromGitLab,
  ocamlPackages,
}:

stdenv.mkDerivation {

  pname = "acgtk";
  version = "2.1.0";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "acg";
    repo = "dev/acgtk";
    tag = "release-2.1.0";
    hash = "sha256-XuPcubt1lvnQio+km6MhmDu41NXNVXKKpzGd/Y1XzLo=";
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
    description = "Toolkit for developing ACG signatures and lexicon";
    license = licenses.cecill20;
    inherit (ocamlPackages.ocaml.meta) platforms;
    maintainers = [ maintainers.jirkamarsik ];
  };
}
