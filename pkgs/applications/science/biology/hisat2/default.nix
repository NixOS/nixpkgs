{stdenv, fetchurl, unzip, which, python}:

stdenv.mkDerivation rec {
  name = "hisat2-${version}";
  version = "2.1.0";

  src = fetchurl {
    url = "ftp://ftp.ccb.jhu.edu/pub/infphilo/hisat2/downloads/hisat2-${version}-source.zip";
    sha256 = "10g73sdf6vqqfhhd92hliw7bbpkb8v4pp5012r5l21zws7p7d8l9";
  };

  buildInputs = [ unzip  which python ];

  installPhase = ''
    mkdir -p $out/bin
    cp hisat2 \
       hisat2-inspect-l \
       hisat2-build-s \
       hisat2-align-l \
       hisat2-inspect \
       hisat2-align-s \
       hisat2-inspect-s \
       hisat2-build-l \
       hisat2-build \
       extract_exons.py \
       extract_splice_sites.py \
       hisat2_extract_exons.py \
       hisat2_extract_snps_haplotypes_UCSC.py \
       hisat2_extract_snps_haplotypes_VCF.py \
       hisat2_extract_splice_sites.py \
       hisat2_simulate_reads.py \
       hisatgenotype_build_genome.py \
       hisatgenotype_extract_reads.py \
       hisatgenotype_extract_vars.py \
       hisatgenotype_hla_cyp.py \
       hisatgenotype_locus.py \
       hisatgenotype.py \
       $out/bin
  '';

  meta = with stdenv.lib; {
    description = "Graph based aligner";
    license = licenses.gpl3;
    homepage = https://ccb.jhu.edu/software/hisat2/index.shtml;
    maintainers = with maintainers; [ jbedo ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };

}
