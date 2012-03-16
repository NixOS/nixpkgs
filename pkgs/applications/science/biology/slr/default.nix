{stdenv, fetchurl, liblapack}:

stdenv.mkDerivation {
  name = "slr-1.4.2";

  src = fetchurl {
    url = http://www.ebi.ac.uk/goldman-srv/SLR/download/v1.4.2/slr_source.tgz;
    sha256 = "03ak7jsz89zism6gx8fr1dwlwjgcmnrr9m6xgqpr0xzikxid02jp";
  };

  buildInputs = [ liblapack ];
  preConfigure = "mkdir bin; cd src";
  makeFlags = "-f Makefile.linux";

  meta = {
    description     = "Phylogenetic Analysis by Maximum Likelihood (PAML)";
    longDescription = ''
SLR is a program to detect sites in coding DNA that are unusually conserved and/or unusually variable (that is, evolving under purify or positive selection) by analysing the pattern of changes for an alignment of sequences on an evolutionary tree.     
'';
    license     = "GPL3";
    homepage    = http://www.ebi.ac.uk/goldman/SLR/;
  };
}
