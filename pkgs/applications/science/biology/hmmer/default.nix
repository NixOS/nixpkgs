{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  version = "3.2.1";
  name = "hmmer-${version}";

  src = fetchurl {
    url = "http://eddylab.org/software/hmmer/${name}.tar.gz";
    sha256 = "171bivy6xhgjsz5nv53n81pc3frnwz29ylblawk2bv46szwjjqd5";
  };

  meta = with stdenv.lib; {
    description = "Biosequence analysis using profile hidden Markov models";
    longDescription = ''
      HMMER is used for searching sequence databases for sequence homologs, and for making sequence alignments. It implements methods using probabilistic models called profile hidden Markov models (profile HMMs).
      HMMER is often used together with a profile database, such as Pfam or many of the databases that participate in Interpro. But HMMER can also work with query sequences, not just profiles, just like BLAST. For example, you can search a protein query sequence against a database with phmmer, or do an iterative search with jackhmmer.
      HMMER is designed to detect remote homologs as sensitively as possible, relying on the strength of its underlying probability models. In the past, this strength came at significant computational expense, but as of the new HMMER3 project, HMMER is now essentially as fast as BLAST.
      HMMER can be downloaded and installed as a command line tool on your own hardware, and now it is also more widely accessible to the scientific community via new search servers at the European Bioinformatics Institute.
    '';
    homepage = http://hmmer.org/;
    license = licenses.gpl3;
    maintainers = [ maintainers.iimog ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
