{
  lib,
  ocamlPackages,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  python3,
  dune,
  makeWrapper,
  pandoc,
  poppler-utils,
  testers,
  docfd,
}:

ocamlPackages.buildDunePackage rec {
  pname = "docfd";
  version = "12.3.2";

  minimalOCamlVersion = "5.1";

  src = fetchFromGitHub {
    owner = "darrenldl";
    repo = "docfd";
    rev = version;
    hash = "sha256-d7c72jXadwBtUqarfdGnEDo9yFwCAeEX0GGVqCe70Ak=";
  };

  patches = [
    # Compatibility with nottui ≥ 0.4
    ./nottui-unix.patch
    # Compatibility with lwd ≥ 0.5
    (fetchpatch {
      url = "https://github.com/darrenldl/docfd/commit/439ff57e80778f684cf8526b3b33c745a02da2a7.patch";
      includes = [ "*.ml" ];
      hash = "sha256-bB+zta2VcrDd42FUD9ExBui787LmtN3PMyb/MJQO7u0=";
    })
  ];

  nativeBuildInputs = [
    python3
    dune
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
    notty-community
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

  meta = {
    description = "TUI multiline fuzzy document finder";
    longDescription = ''
      Think interactive grep for text and other document files.
      Word/token based instead of regex and line based, so you
      can search across lines easily. Aims to provide good UX via
      integration with common text editors and other file viewers.
    '';
    homepage = "https://github.com/darrenldl/docfd";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chewblacka ];
    platforms = lib.platforms.all;
    mainProgram = "docfd";
  };
}
