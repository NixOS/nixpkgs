{
  lib,
  ocamlPackages,
  stdenv,
  fetchFromGitHub,
  python3,
<<<<<<< HEAD
  dune,
=======
  dune_3,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  makeWrapper,
  pandoc,
  poppler-utils,
  testers,
  docfd,
}:

ocamlPackages.buildDunePackage rec {
  pname = "docfd";
<<<<<<< HEAD
  version = "12.2.0";
=======
  version = "12.1.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  minimalOCamlVersion = "5.1";

  src = fetchFromGitHub {
    owner = "darrenldl";
    repo = "docfd";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-0URs7X94/2D0WLpVBXjYZ3zDR3uGXSVG+WLdsAqVKBg=";
=======
    hash = "sha256-fDvjnqAH0ALP1im34vxmXtO7kst0G/iPu3VLLBas5YI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  # Compatibility with nottui ≥ 0.4
  patches = [ ./nottui-unix.patch ];

  nativeBuildInputs = [
    python3
<<<<<<< HEAD
    dune
=======
    dune_3
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    makeWrapper
  ];

  buildInputs = with ocamlPackages; [
    cmdliner
    containers-data
    decompress
    diet
    digestif
    eio_main
    lwd
    nottui
    nottui-unix
    notty
    ocaml_sqlite3
    ocolor
    oseq
    ppx_deriving
    ppxlib
    progress
    re
    spelll
    timedesc
    uuseg
    yojson
  ];

  postInstall = ''
    wrapProgram $out/bin/docfd --prefix PATH : "${
      lib.makeBinPath [
        pandoc
        poppler-utils
      ]
    }"
  '';

  passthru.tests.version = testers.testVersion { package = docfd; };

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "TUI multiline fuzzy document finder";
    longDescription = ''
      Think interactive grep for text and other document files.
      Word/token based instead of regex and line based, so you
      can search across lines easily. Aims to provide good UX via
      integration with common text editors and other file viewers.
    '';
    homepage = "https://github.com/darrenldl/docfd";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chewblacka ];
    platforms = lib.platforms.all;
=======
    license = licenses.mit;
    maintainers = with maintainers; [ chewblacka ];
    platforms = platforms.all;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "docfd";
  };
}
