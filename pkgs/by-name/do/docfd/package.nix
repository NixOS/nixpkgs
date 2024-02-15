{ lib, ocamlPackages, fetchFromGitHub, python3, dune_3, makeWrapper, poppler_utils, fzf }:

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
  buildInputs = with ocamlPackages; [ oseq spelll notty nottui lwd cmdliner domainslib digestif yojson eio_main containers-data timedesc ];

  postInstall = ''
  # docfd needs pdftotext from popler_utils to allow pdf search
  # also fzf for "docfd ?" usage
  wrapProgram $out/bin/docfd --prefix PATH : "${lib.makeBinPath [ poppler_utils fzf ]}"
  '';

  meta = with lib; {
    description = "TUI multiline fuzzy document finder";
    longDescription = ''
      TUI multiline fuzzy document finder.
      Think interactive grep for both text files and PDFs, but word/token based
      instead of regex and line based, so you can search across lines easily.
      Docfd aims to provide good UX via integration with common text editors
      and PDF viewers, so you can jump directly to a search result with a
      single key press.
    '';
    homepage = "https://github.com/darrenldl/docfd";
    license = licenses.mit;
    maintainers = with maintainers; [ chewblacka ];
    platforms = platforms.all;
    mainProgram = "docfd";
  };
}
