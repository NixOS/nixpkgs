{ lib, ocamlPackages, fetchFromGitHub, python3, dune_3, makeWrapper, poppler_utils }:

ocamlPackages.buildDunePackage rec {
  pname = "docfd";
  version = "2.1.0";

  minimalOCamlVersion = "5.1";

  src = fetchFromGitHub {
    owner = "darrenldl";
    repo = "docfd";
    rev = version;
    hash = "sha256-1DobGm6nI14951KNKEE0D3AF1TFsWQUEhe4L1PdWBDw=";
  };

  nativeBuildInputs = [ python3 dune_3 makeWrapper ];
  buildInputs = [ poppler_utils ] ++
    (with ocamlPackages; [ oseq spelll notty nottui lwd cmdliner domainslib digestif yojson eio_main containers-data timedesc ]);

  postInstall = ''
  # docfd needs pdftotext from popler_utils to allow pdf search
  wrapProgram $out/bin/docfd --prefix PATH : "${lib.getBin poppler_utils}/bin/"
  '';

  meta = with lib; {
    description = "TUI multiline fuzzy document finder";
    longDescription = ''
      Interactive grep, but word/token/phrase based rather than regex
      and line based, so you can search across multiple lines (simlar to
      Recoll but TUI).
      Aims to provide a good UX via text editor and PDF viewer integration.
      When opening a text file, Docfd opens file at first line of search
      result. If PDF, then Docfd opens file at first page of the search
      result and starts a text search of the most unique word of the matched
      phrase within the same page.
      Main intended use case: navigating directories of notes and PDFs.
    '';
    homepage = "https://github.com/darrenldl/docfd";
    license = licenses.mit;
    maintainers = with maintainers; [ chewblacka ];
    platforms = platforms.all;
    mainProgram = "docfd";
  };
}
