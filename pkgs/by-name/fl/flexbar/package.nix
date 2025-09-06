{ lib
, stdenv
, cmake
, fetchFromGitHub
, bzip2
, tbb
, zlib
}:

let
  seqanSrc = fetchFromGitHub {
    owner = "seqan";
    repo = "seqan";
    sparseCheckout = [
      "include"
    ];
    rev = "seqan-v2.4.0";
    sha256 = "sha256-tfwlEbTK99FfufhKFORwv3I8t68djeWmA4E2PpOEqzQ=";
  };
in

stdenv.mkDerivation rec {
  pname = "flexbar";
  version = "3.5.0";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ tbb zlib bzip2 ];

  src = fetchFromGitHub {
    owner = "seqan";
    repo = "flexbar";
    rev = "v${version}";
    sha256 = "sha256-CYJTo8eOZtkIjMkPCm3SwyF3bq87LcqFjX3EykUqDPA=";
  };

  postUnpack = ''
    cp -r ${seqanSrc}/include source/
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp flexbar $out/bin/flexbar

    runHook postInstall
  '';

  meta = {
    description = "Flexible DNA barcode and adapter removal tool";
    longDescription = ''
      The program Flexbar preprocesses high-throughput sequencing data
      efficiently. It demultiplexes barcoded runs and removes adapter
      sequences. Several adapter removal presets for Illumina libraries are
      included. Flexbar computes exact overlap alignments using SIMD and
      multicore parallelism. Moreover, trimming and filtering features are
      provided, e.g. trimming of homopolymers at read ends. Flexbar increases
      read mapping rates and improves genome as well as transcriptome
      assemblies. Unique molecular identifiers can be extracted in a flexible
      way. The software supports data in fasta and fastq format from multiple
      sequencing platforms. '';
    homepage = "https://github.com/seqan/flexbar/wiki";
    downloadPage = "https://github.com/seqan/flexbar/releases";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.kupac ];
  };
}
