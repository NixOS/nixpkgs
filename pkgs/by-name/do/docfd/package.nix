{ lib
, ocamlPackages
, fetchFromGitHub
, python3
, dune_3
}:

ocamlPackages.buildDunePackage rec {
  pname = "docfd";
  version = "3.0.0";

  minimalOCamlVersion = "5.1";

  src = fetchFromGitHub {
    owner = "darrenldl";
    repo = "docfd";
    rev = version;
    hash = "sha256-pJ5LlOfC+9NRfY7ng9LAxEnjr+mtJmhRNTo9Im6Lkbo=";
  };

  nativeBuildInputs = [ python3 dune_3 ];
  buildInputs = with ocamlPackages; [
    cmdliner
    containers-data
    digestif
    domainslib
    eio_main
    lwd
    nottui
    notty
    ocolor
    oseq
    spelll
    timedesc
    yojson
  ];

  meta = with lib; {
    description = "TUI multiline fuzzy document finder";
    longDescription = ''
      Think interactive grep for both text and other document files, but
      word/token based instead of regex and line based, so you can search
      across lines easily. Aims to provide good UX via integration with
      common text editors and other file viewers.
      Optional dependencies:
        fzf - for fuzzy file picker with "docfd ?".
        poppler_utils - for pdf search.
        pandoc - for .epub, .odt, .docx, .fb2, .ipynb, .html, & .htm files.
    '';
    homepage = "https://github.com/darrenldl/docfd";
    license = licenses.mit;
    maintainers = with maintainers; [ chewblacka ];
    platforms = platforms.all;
    mainProgram = "docfd";
  };
}
