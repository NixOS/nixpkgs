{ stdenv, fetchurl, coreutils, fltk, libjpeg }:

stdenv.mkDerivation rec {
  version = "5.0";
  pname = "seaview";

  src = fetchurl {
    url = "ftp://pbil.univ-lyon1.fr/pub/mol_phylogeny/seaview/archive/seaview_${version}.tar.gz";
    sha256 = "0gzjqf5mm91pa1drwxvz229bv6l995npdggngszh6z6j4pfh8j7c";
  };

  buildInputs = [ fltk libjpeg ];

  patchPhase = "sed -i 's#PATH=/bin:/usr/bin rm#'${coreutils}/bin/rm'#' seaview.cxx";
  installPhase = "mkdir -p $out/bin; cp seaview $out/bin";

  meta = with stdenv.lib; {
    description = "GUI for molecular phylogeny";
    longDescription = ''
      SeaView is a multiplatform, graphical user interface for multiple sequence alignment and molecular phylogeny.
        - SeaView reads and writes various file formats (NEXUS, MSF, CLUSTAL, FASTA, PHYLIP, MASE, Newick) of DNA and protein sequences and of phylogenetic trees.
        - SeaView drives programs muscle or Clustal Omega for multiple sequence alignment, and also allows to use any external alignment algorithm able to read and write FASTA-formatted files.
        - Seaview drives the Gblocks program to select blocks of evolutionarily conserved sites.
        - SeaView computes phylogenetic trees by
          + parsimony, using PHYLIP's dnapars/protpars algorithm,
          + distance, with NJ or BioNJ algorithms on a variety of evolutionary distances,
          + maximum likelihood, driving program PhyML 3.1.
        - Seaview can use the Transfer Bootstrap Expectation method to compute the bootstrap support of PhyML and distance trees.
        - SeaView prints and draws phylogenetic trees on screen, SVG, PDF or PostScript files.
        - SeaView allows to download sequences from EMBL/GenBank/UniProt using the Internet.

      Seaview is published in:

          Gouy M., Guindon S. & Gascuel O. (2010) SeaView version 4 : a multiplatform graphical user interface for sequence alignment and phylogenetic tree building. Molecular Biology and Evolution 27(2):221-224.
    '';
    homepage = http://doua.prabi.fr/software/seaview;
    license = licenses.gpl3;
    maintainers = [ maintainers.iimog ];
    platforms = platforms.linux;
  };
}
