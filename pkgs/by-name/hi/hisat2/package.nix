{
  lib,
  stdenv,
  fetchFromGitHub,
  unzip,
  which,
  python3,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "hisat2";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "DaehwanKimLab";
    repo = "hisat2";
    rev = "v${version}";
    sha256 = "sha256-Ub7Oe363bU+R1xGiWVDkbXGV0PWJ5x2D9de+jTJSwOA=";
  };

  nativeBuildInputs = [
    unzip
    which
  ];
  buildInputs = [
    python3
    perl
  ];

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

  meta = {
    description = "Graph based aligner";
    license = lib.licenses.gpl3Plus;
    homepage = "https://daehwankimlab.github.io/hisat2/";
    maintainers = with lib.maintainers; [ jbedo ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };

}
