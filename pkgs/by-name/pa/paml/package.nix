{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "paml";
  version = "4.10.7";

  src = fetchFromGitHub {
    owner = "abacus-gene";
    repo = "paml";
    tag = finalAttrs.version;
    hash = "sha256-P/oHaLxoQzjFuvmHyRdShHv1ayruy6O/I9w8aTyya2s=";
  };

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-D_POSIX_C_SOURCE";

  preBuild = ''
    cd ./src/
  '';

  installPhase = ''
    runHook preInstall

    mkdir -pv $out/bin
    cp -v codeml $out/bin
    cp -v baseml $out/bin
    cp -v basemlg $out/bin
    cp -v chi2 $out/bin
    cp -v codeml $out/bin
    cp -v evolver $out/bin
    cp -v mcmctree $out/bin
    cp -v pamp $out/bin
    cp -v yn00 $out/bin

    runHook postInstall
  '';

  meta = {
    description = "Phylogenetic Analysis by Maximum Likelihood (PAML)";
    longDescription = "PAML is a package of programs for phylogenetic analyses of DNA or protein sequences using maximum likelihood. It is maintained and distributed for academic use free of charge by Ziheng Yang. ANSI C source codes are distributed for UNIX/Linux/Mac OSX, and executables are provided for MS Windows. PAML is not good for tree making. It may be used to estimate parameters and test hypotheses to study the evolutionary process, when you have reconstructed trees using other programs such as PAUP*, PHYLIP, MOLPHY, PhyML, RaxML, etc.";
    license = lib.licenses.gpl3Only;
    homepage = "http://abacus.gene.ucl.ac.uk/software/paml.html";
    changelog = "https://github.com/abacus-gene/paml/releases/tag/${finalAttrs.version}";
    platforms = lib.platforms.unix;
  };
})
