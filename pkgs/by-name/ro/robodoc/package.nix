{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "robodoc";
  version = "4.99.44";

  src = fetchFromGitHub {
    owner = "gumpu";
    repo = "ROBODoc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-l3prSdaGhOvXmZfCPbsZJNocO7y20zJjLQpajRTJOqE=";
  };

  patches = [
    (fetchpatch {
      name = "troff_generator-fix";
      url = "https://github.com/gumpu/ROBODoc/commit/0f8b35c42523810415bec70bb2200d2ecb41c82f.patch?index=full";
      hash = "sha256-Pbuc1gHrOeHbR4QT/dZ8wP+vqYQlilayjCGKOJP5wvk=";
    })
  ];

  postConfigure = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace Docs/makefile.am \
      --replace-fail 'man1_MANS = robodoc.1 robohdrs.1' 'man1_MANS ='
  '';

  nativeBuildInputs = [ autoreconfHook ];

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "https://github.com/gumpu/ROBODoc";
    description = "Documentation Extraction Tool";
    longDescription = ''
      ROBODoc is program documentation tool. The idea is to include for every
      function or procedure a standard header containing all sorts of
      information about the procedure or function. ROBODoc extracts these
      headers from the source file and puts them in a separate
      autodocs-file. ROBODoc thus allows you to include the program
      documentation in the source code and avoid having to maintain two separate
      documents. Or as Petteri puts it: "robodoc is very useful - especially for
      programmers who don't like writing documents with Word or some other
      strange tool."

      ROBODoc can format the headers in a number of different formats: HTML,
      RTF, LaTeX, or XML DocBook. In HTML mode it can generate cross links
      between headers. You can even include parts of your source code.

      ROBODoc works with many programming languages: For instance C, Pascal,
      Shell Scripts, Assembler, COBOL, Occam, Postscript, Forth, Tcl/Tk, C++,
      Java -- basically any program in which you can use remarks/comments.
    '';
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "robodoc";
  };
})
