{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "clustalw2-2.0.5";
  src = fetchurl {
    url = ftp://ftp.ebi.ac.uk/pub/software/clustalw2/clustalw-2.0.5-src.tar.gz;
    sha256 = "0sh40ni53jdnb0pbnlhrfcan8dfsgqi9zsas2z24bhcw71yvn8ba";
  };

  meta = {
    description     = "General purpose multiple sequence alignment program for DNA or proteins";
    longDescription = ''ClustalW2 is a general purpose multiple sequence
    alignment program for DNA or proteins. It produces biologically meaningful
    multiple sequence alignments of divergent sequences. It calculates the best
    match for the selected sequences, and lines them up so that the identities,
    similarities and differences can be seen.  Evolutionary relationships can
    be seen via viewing Cladograms or Phylograms.'';
    license     = "non-commercial";
    homepage    = http://www.ebi.ac.uk/Tools/clustalw2/;
  };
}
