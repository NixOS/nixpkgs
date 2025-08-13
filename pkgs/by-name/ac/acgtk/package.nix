{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
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

  # Compatibility with fmt 0.10.0
  patches = [
    (fetchpatch {
      url = "https://gitlab.inria.fr/ACG/dev/ACGtk/-/commit/613454b376d10974f539ab398a269be061c5bc9c.patch";
      hash = "sha256-l/V8oEgntnFtrhpTQSk7PkpaX+dBq4izG/tloCQRbDY=";
    })
  ];

  # Compatibility with logs 0.8.0
  postPatch = ''
    substituteInPlace src/utils/dune \
      --replace-warn 'logs mtime' 'logs logs.fmt mtime'
  '';

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

  meta = {
    homepage = "https://acg.loria.fr/";
    description = "Toolkit for developing ACG signatures and lexicon";
    license = lib.licenses.cecill20;
    inherit (ocamlPackages.ocaml.meta) platforms;
    maintainers = with lib.maintainers; [ jirkamarsik ];
  };
}
