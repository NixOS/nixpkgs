{stdenv, fetchurl, perl, paml}:

stdenv.mkDerivation {
  name = "pal2nal-12";
  src = fetchurl {
    url = http://coot.embl.de/pal2nal/distribution/pal2nal.v12.tar.gz;
    sha256 = "1qj9sq5skpa7vyccl9gxc5ls85jwiq8j6mr8wvacz4yhyg0afy04";
  };

  installPhase = ''
    mkdir -p $out/bin

    cp -v pal2nal.pl $out/bin 

    mkdir -p $out/doc

    cp -v README $out/doc
  '';

  meta = {
    description     = "Program for aligning nucleotide sequences based on an aminoacid alignment";
    longDescription = ''
   PAL2NAL is a program that converts a multiple sequence alignment of proteins and the corresponding DNA (or mRNA) sequences into a codon alignment. The program automatically assigns the corresponding codon sequence even if the input DNA sequence has mismatches with the input protein sequence, or contains UTRs, polyA tails. It can also deal with frame shifts in the input alignment, which is suitable for the analysis of pseudogenes. The resulting codon alignment can further be subjected to the calculation of synonymous (KS) and non-synonymous (KA) substitution rates.

If the input is a pair of sequences, PAL2NAL automatically calculates KS and KA by the codeml program in PAML.
'';
    license        = "non-commercial";
    homepage       = http://coot.embl.de/pal2nal/;
    pkgMaintainer  = "Pjotr Prins";
  };
}
