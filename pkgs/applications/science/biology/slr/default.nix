{stdenv, fetchurl, liblapack}:

stdenv.mkDerivation {
  name = "slr";
  src = fetchurl {
    url = http://www.ebi.ac.uk/goldman-srv/SLR/download/current/slr_source.tgz;
    sha256 = "0i81fv201p187mim4zakipxnhzqdvd3p5a9qa59xznc6458r2zsn";
  };

  buildInputs = [ liblapack ];
  buildPhase = ''
    cd src
    ls
    make -fMakefile.linux
  '';
  installPhase = ''
    mkdir -p $out/bin
    cp -v ../Slr $out/bin 
  '';

  meta = {
    description     = "Phylogenetic Analysis by Maximum Likelihood (PAML)";
    longDescription = ''
SLR is a program to detect sites in coding DNA that are unusually conserved and/or unusually variable (that is, evolving under purify or positive selection) by analysing the pattern of changes for an alignment of sequences on an evolutionary tree.     
'';
    license     = "GPL3";
    homepage    = http://www.ebi.ac.uk/goldman/SLR/;
  };
}
