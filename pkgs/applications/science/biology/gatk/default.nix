{ lib, stdenv, fetchzip, jre, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "gatk";
  version = "4.2.6.1";
  src = fetchzip {
    url = "https://github.com/broadinstitute/gatk/releases/download/${version}/gatk-${version}.zip";
    sha256 = "0hjlsl7fxf3ankyjidqhwxc70gjh6z4lnjzw6b5fldzb0qvgfvy8";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ jre ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/libexec/gatk
    cp $src/gatk-package-${version}-local.jar $out/libexec/gatk/gatk.jar
    mkdir -p $out/bin
    makeWrapper ${jre}/bin/java $out/bin/gatk --add-flags "-jar $out/libexec/gatk/gatk.jar"
  '';

  meta = with lib; {
    homepage = "https://gatk.broadinstitute.org/hc/en-us";
    description = "A wide variety of tools with a primary focus on variant discovery and genotyping." ;
    license = licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ binaryBytecode ] ;
    maintainers = with maintainers; [ apraga ];
    longDescription = ''
      The GATK is the industry standard for identifying SNPs and indels in germline
      DNA and RNAseq data. Its scope is now expanding to include somatic short variant
      calling, and to tackle copy number (CNV) and structural variation (SV). In
      addition to the variant callers themselves, the GATK also includes many
      utilities to perform related tasks such as processing and quality control of
      high-throughput sequencing data, and bundles the popular Picard toolkit.

      These tools were primarily designed to process exomes and whole genomes
      generated with Illumina sequencing technology, but they can be adapted to handle
      a variety of other technologies and experimental designs. And although it was
      originally developed for human genetics, the GATK has since evolved to handle
      genome data from any organism, with any level of ploidy.
    '';
  };
}
