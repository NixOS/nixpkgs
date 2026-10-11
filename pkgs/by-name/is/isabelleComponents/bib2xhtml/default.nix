{
  stdenvNoCC,
  fetchFromGitHub,
  lib,
  installShellFiles,
  perlPackages,
  writeTextFile,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "bib2xhtml";
  version = "3.0-unstable-2019-03-04";

  outputs = [
    "out"
    "tex"
  ];

  src = fetchFromGitHub {
    owner = "dspinellis";
    repo = "bib2xhtml";
    rev = "ab8c90bfd8c037c44e2adc9a7b1a71ccf4ae8161";
    hash = "sha256-dFn1uHGtvxwAnaNS4Hbdi4IrpLELYb4J2tJCCiF0KQo=";
  };

  postPatch = ''
    mv bib2xhtml.man bib2xhtml.1
  '';

  nativeBuildInputs = [
    perlPackages.perl
    installShellFiles
  ];

  buildInputs = [
    perlPackages.perl
  ];

  propagatedBuildInputs = [
    perlPackages.PDFAPI2
  ];

  buildPhase = ''
    runHook preBuild

    perl gen-bst.pl

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $tex/bibtex/bst/bib2xhtml

    install -Dm755 ./bib2xhtml.pl $out/bin/bib2xhtml
    install -Dm755 ./bibsearch.pl $out/bin/bibsearch

    install -m644 ./*.bst $tex/bibtex/bst/bib2xhtml

    installManPage bib2xhtml.1

    runHook postInstall
  '';

  passthru.settings = writeTextFile {
    name = "bib2xhtml-settings";
    text = ''
      ISABELLE_BIB2XHTML="${lib.getExe' finalAttrs.finalPackage "bib2xhtml"}"
      BIB2XHTML_HOME="${finalAttrs.finalPackage.tex}/bibtex/bst/bib2xhtml"
    '';
    destination = "/etc/settings";
  };

  meta = {
    description = "Convert BibTeX references into XHTML";
    homepage = "http://www.spinellis.gr/sw/textproc/bib2xhtml/";
    license = lib.licenses.gpl2;
    maintainers = [ lib.maintainers.sempiternal-aurora ];
    platforms = lib.platforms.unix;
  };
})
