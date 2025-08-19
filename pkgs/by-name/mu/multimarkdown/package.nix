{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  perl,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "multimarkdown";
  version = "6.7.0";

  src = fetchFromGitHub {
    owner = "fletcher";
    repo = "MultiMarkdown-6";
    tag = finalAttrs.version;
    hash = "sha256-b6yCn0NFpONI7WwfjDOc0d2nCKMIiUXi+rsnytiNc0Q=";
  };

  postPatch = ''
    patchShebangs tools/enumsToPerl.pl
  '';

  nativeBuildInputs = [
    cmake
    perl
    pkg-config
  ];

  meta = {
    homepage = "https://fletcher.github.io/MultiMarkdown-6/introduction.html";
    description = "Derivative of Markdown that adds new syntax features";
    longDescription = ''
      MultiMarkdown is a lightweight markup language created by
      Fletcher T. Penney and based on Markdown, which supports
      more export-formats (html, latex, beamer, memoir, odf, opml,
      lyx, mmd) and implements some added features currently not
      available with plain Markdown syntax.

      It adds the following features to Markdown:

      - footnotes
      - tables
      - citations and bibliography (works best in LaTeX using BibTeX)
      - math support
      - automatic cross-referencing ability
      - smart typography, with support for multiple languages
      - image attributes
      - table and image captions
      - definition lists
      - glossary entries (LaTeX only)
      - document metadata (e.g. title, author, date, etc.)
    '';
    license = with lib.licenses; [ mit ];
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ ];
  };
})
