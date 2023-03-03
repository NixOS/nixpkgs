{lib, stdenv, fetchFromGitHub, unzip, which, python3, perl}:

stdenv.mkDerivation rec {
  pname = "hisat2";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "DaehwanKimLab";
    repo = "hisat2";
    rev = "v${version}";
    sha256 = "0lmzdhzjkvxw7n5w40pbv5fgzd4cz0f9pxczswn3d4cr0k10k754";
  };

  nativeBuildInputs = [ unzip which ];
  buildInputs = [ python3 perl ];

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
       $out/bin
  '';

  meta = with lib; {
    description = "Graph based aligner";
    license = licenses.gpl3Plus;
    homepage = "https://daehwankimlab.github.io/hisat2/";
    maintainers = with maintainers; [ jbedo ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };

}
