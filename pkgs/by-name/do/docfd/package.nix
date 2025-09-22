{
  lib,
  ocamlPackages,
  stdenv,
  fetchFromGitHub,
  python3,
  dune_3,
  makeWrapper,
  pandoc,
  poppler-utils,
  testers,
  docfd,
}:

ocamlPackages.buildDunePackage rec {
  pname = "docfd";
  version = "11.0.1";

  minimalOCamlVersion = "5.1";

  src = fetchFromGitHub {
    owner = "darrenldl";
    repo = "docfd";
    rev = version;
    hash = "sha256-uRC2QBn4gAfS9u85YaNH2Mm2C0reP8FnDHbyloY+OC8=";
  };

  # Compatibility with nottui ≥ 0.4
  patches = [ ./nottui-unix.patch ];

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
