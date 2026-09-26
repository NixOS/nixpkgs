{
  lib,
  stdenvNoCC,
  writableTmpDirAsHomeHook,
  fetchFromGitHub,
  texliveSmall,
  writeTextFile,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "latex-eptcs";
  version = "1.7.0";

  outputs = [
    "out"
    "tex"
    "texdoc"
  ];

  src = fetchFromGitHub {
    owner = "EPTCS";
    repo = "style";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d8dKVVgCnmk8Acz5VvOCJMlZv3QWpupjQH0Egi1vc/Y=";
  };

  nativeBuildInputs = [
    (texliveSmall.withPackages (
      ps: with ps; [
        rsfs
        latex-uni8
        underscore
        latexmk
      ]
    ))
    writableTmpDirAsHomeHook # Need a writable $HOME for latexmk
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $tex/tex/latex/eptcs $tex/bibtex/bst/eptcs
    install -m644 *.{cls,def,clo,sty} $tex/tex/latex/eptcs
    install -m644 *.bst $tex/bibtex/bst/eptcs

    mkdir -p $texdoc/doc/tex/latex/eptcs
    install -m644 *.pdf $texdoc/doc/tex/latex/eptcs

    mkdir -p $out
    ln -s $tex/tex/latex/eptcs/eptcs.cls $out/eptcs.cls
    ln -s $tex/bibtex/bst/eptcs/eptcs.bst $out/eptcs.bst

    runHook postInstall
  '';

  passthru = {
    tlDeps = ps: [ ps.latex ];
    settings = writeTextFile {
      name = "eptcs-settings";
      text = ''
        ISABELLE_EPTCS_HOME="${finalAttrs.finalPackage}"
      '';
      destination = "/etc/settings";
    };
  };

  meta = {
    description = "EPTCS LaTeX style files";
    homepage = "http://style.eptcs.org/";
    maintainers = [ lib.maintainers.sempiternal-aurora ];
    license = lib.licenses.cc-by-40;
    platforms = lib.platforms.all;
  };
})
