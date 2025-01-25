{
  lib,
  stdenv,
  fetchFromGitHub,
  ghostscript,
}:

stdenv.mkDerivation rec {
  pname = "lout";
  version = "3.43";

  src = fetchFromGitHub {
    owner = "william8000";
    repo = pname;
    rev = version;
    hash = "sha256-YUFrlM7BnDlG1rUV90yBvWG6lOKW5qKxs/xdq6I/kI0=";
  };

  buildInputs = [ ghostscript ];

  makeFlags = [
    "PREFIX=$(out)/"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  meta = {
    description = "Document layout system similar in style to LaTeX";

    longDescription = ''
      The Lout document formatting system is now reads a high-level
      description of a document similar in style to LaTeX and produces
      a PostScript or plain text output file.

      Lout offers an unprecedented range of advanced features,
      including optimal paragraph and page breaking, automatic
      hyphenation, PostScript EPS file inclusion and generation,
      equation formatting, tables, diagrams, rotation and scaling,
      sorted indexes, bibliographic databases, running headers and
      odd-even pages, automatic cross referencing, multilingual
      documents including hyphenation (most European languages are
      supported), formatting of computer programs, and much more, all
      ready to use.  Furthermore, Lout is easily extended with
      definitions which are very much easier to write than troff of
      TeX macros because Lout is a high-level, purely functional
      language, the outcome of an eight-year research project that
      went back to the beginning.
    '';

    homepage = "https://github.com/william8000/lout";

    license = lib.licenses.gpl3Plus;

    platforms = lib.platforms.all;
    maintainers = [ ];
  };
}
