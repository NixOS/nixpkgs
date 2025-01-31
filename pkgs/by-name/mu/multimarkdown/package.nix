{ lib
, stdenv
, fetchFromGitHub
, cmake
, perl
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "multimarkdown";
  version = "6.6.0";

  src = fetchFromGitHub {
    owner = "fletcher";
    repo = "MultiMarkdown-6";
    rev = version;
    hash = "sha256-emJbY0wucoc/GdjlILoeqjwuwuPpTjXTqZN0gUKOyLg=";
  };

  postPatch = ''
    patchShebangs tools/enumsToPerl.pl
  '';

  postInstall = ''
    # Move files from $out/ to sub directories to prevent conflicts
    # with other packages:
    mkdir -p $out/share/doc/multimarkdown/
    mv $out/LICENSE.txt $out/README.txt $out/share/doc/multimarkdown/
  '';

  nativeBuildInputs = [
    cmake
    perl
    pkg-config
  ];

  meta = with lib; {
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
    license = with licenses; [ mit ];
    platforms = platforms.all;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
