{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "diamond";
  version = "2.1.14";

  src = fetchFromGitHub {
    owner = "bbuchfink";
    repo = "diamond";
    rev = "v${version}";
    sha256 = "sha256-w6+lSc2YZ1PwPj3p6ieI/yTkoiSLWH2Za863n4BTClo=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib ];

  meta = with lib; {
    description = "Accelerated BLAST compatible local sequence aligner";
    mainProgram = "diamond";
    longDescription = ''
      DIAMOND is a sequence aligner for protein and translated DNA searches, designed for high performance analysis of big sequence data. The key features are:
      - Pairwise alignment of proteins and translated DNA at 100x-10,000x speed of BLAST.
      - Frameshift alignments for long read analysis.
      - Low resource requirements and suitable for running on standard desktops or laptops.
      - Various output formats, including BLAST pairwise, tabular and XML, as well as taxonomic classification.

      When using the tool in published research, please cite:
      - Buchfink B, Reuter K, Drost HG, "Sensitive protein alignments at tree-of-life scale using DIAMOND", Nature Methods 18, 366–368 (2021). doi:10.1038/s41592-021-01101-x
    '';
    homepage = "https://github.com/bbuchfink/diamond";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
  };
}
