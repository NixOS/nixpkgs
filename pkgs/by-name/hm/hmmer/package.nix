{
  lib,
  stdenv,
  fetchurl,
  easel,
  perl,
  python3,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.4";
  pname = "hmmer";

  src = fetchurl {
    url = "http://eddylab.org/software/hmmer/hmmer-${finalAttrs.version}.tar.gz";
    hash = "sha256-ynDZT9DPJxvXBjQjqrsRbULeUzEXNDqbJ6ZcF/8G+/M=";
  };

  enableParallelBuilding = true;

  doCheck = true;

  nativeCheckInputs = [
    perl
    python3
  ];

  preCheck = ''
    install -Dm755 ${easel.src}/devkit/sqc easel/devkit/sqc
    patchShebangs easel/devkit/sqc testsuite/* src/hmmpress.itest.pl
  '';

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgram = "${placeholder "out"}/bin/hmmalign";

  versionCheckProgramArg = "-h";

  meta = {
    description = "Biosequence analysis using profile hidden Markov models";
    longDescription = ''
      HMMER is used for searching sequence databases for sequence homologs, and for making sequence alignments. It implements methods using probabilistic models called profile hidden Markov models (profile HMMs).
      HMMER is often used together with a profile database, such as Pfam or many of the databases that participate in Interpro. But HMMER can also work with query sequences, not just profiles, just like BLAST. For example, you can search a protein query sequence against a database with phmmer, or do an iterative search with jackhmmer.
      HMMER is designed to detect remote homologs as sensitively as possible, relying on the strength of its underlying probability models. In the past, this strength came at significant computational expense, but as of the new HMMER3 project, HMMER is now essentially as fast as BLAST.
      HMMER can be downloaded and installed as a command line tool on your own hardware, and now it is also more widely accessible to the scientific community via new search servers at the European Bioinformatics Institute.
    '';
    homepage = "http://hmmer.org/";
    changelog = "https://github.com/EddyRivasLab/hmmer/blob/hmmer-${finalAttrs.version}/release-notes/RELEASE-${finalAttrs.version}.md";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.iimog ];
    platforms = lib.platforms.unix;
  };
})
