{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "paml-4.1";
  src = fetchurl {
    url = http://abacus.gene.ucl.ac.uk/software/paml4.1.tar.gz;
    sha256 = "1w8ih7h9xfbnmzmbql5l1hjkgzp17wjvxjfgc76zbcsb61b0ls34";
  };

  preBuild = ''
    cd ./src/
  '';
  installPhase = ''
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
  '';

  meta = {
    description     = "Phylogenetic Analysis by Maximum Likelihood (PAML)";
    longDescription = ''PAML is a package of programs for phylogenetic analyses of DNA or protein sequences using maximum likelihood. It is maintained and distributed for academic use free of charge by Ziheng Yang. ANSI C source codes are distributed for UNIX/Linux/Mac OSX, and executables are provided for MS Windows. PAML is not good for tree making. It may be used to estimate parameters and test hypotheses to study the evolutionary process, when you have reconstructed trees using other programs such as PAUP*, PHYLIP, MOLPHY, PhyML, RaxML, etc.'';
    license     = "non-commercial";
    homepage    = http://abacus.gene.ucl.ac.uk/software/paml.html; 
    pkgMaintainer = http://biolib.open-bio.org/;
  };
}
