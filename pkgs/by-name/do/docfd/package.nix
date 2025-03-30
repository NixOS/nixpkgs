{
  lib,
  ocamlPackages,
  stdenv,
  overrideSDK,
  fetchFromGitHub,
  python3,
  dune_3,
  makeWrapper,
  pandoc,
  poppler-utils,
  testers,
  docfd,
}:

let
  # Needed for x86_64-darwin
  buildDunePackage' = ocamlPackages.buildDunePackage.override {
    stdenv = if stdenv.hostPlatform.isDarwin then overrideSDK stdenv "11.0" else stdenv;
  };
in
buildDunePackage' rec {
  pname = "docfd";
  version = "10.1.3";

  minimalOCamlVersion = "5.1";

  src = fetchFromGitHub {
    owner = "darrenldl";
    repo = "docfd";
    rev = version;
    hash = "sha256-ZD1nKl/hfidlTGdBnNINt2EmlUmFWaJjSvY3wkyJJcg=";
  };

  nativeBuildInputs = [
    python3
    dune_3
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

  meta = with lib; {
    description = "TUI multiline fuzzy document finder";
    longDescription = ''
      Think interactive grep for text and other document files.
      Word/token based instead of regex and line based, so you
      can search across lines easily. Aims to provide good UX via
      integration with common text editors and other file viewers.
    '';
    homepage = "https://github.com/darrenldl/docfd";
    license = licenses.mit;
    maintainers = with maintainers; [ chewblacka ];
    platforms = platforms.all;
    mainProgram = "docfd";
  };
}
